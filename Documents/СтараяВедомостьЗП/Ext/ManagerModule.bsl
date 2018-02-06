﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Проводка по депонированию заработной платы
	// Дт 3520 / Кт 3610
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата) КАК СчетДт,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ЗадолженностьПоДепонированнойЗаработнойПлате) КАК СчетКт,
		|	ТаблицаДокумента.ФизЛицо КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ТаблицаДокумента.ФизЛицо КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ТаблицаДокумента.СуммаКВыплате КАК Сумма,
		|	&ВалютаРегламентированногоУчета КАК ВалютаДт,
		|	ТаблицаДокумента.СуммаКВыплате КАК ВалютнаяСуммаДт,
		|	&ВалютаРегламентированногоУчета КАК ВалютаКт,
		|	ТаблицаДокумента.СуммаКВыплате КАК ВалютнаяСуммаКт,
		|	""Депонированние заработной платы"" КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаЗарплата КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ТаблицаДокумента.ВыплаченностьЗарплаты = ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Задепонировано)";
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
КонецПроцедуры 

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ПериодРегистрации
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ВедомостьЗП КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.ВыплаченностьЗарплаты,
		|	ТаблицаДокумента.СуммаКВыплате
		|ПОМЕСТИТЬ ВременнаяТаблицаЗарплата
		|ИЗ
		|	Документ.ВедомостьЗП.Зарплата КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);			 
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Сформировать печатные формы объектов
//
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	Перем Ошибки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
		Если ИмяМакета = "ВедомостьПеречисленияНаКартСчета" Тогда     
			
			ТабличныйДокумент.КлючПараметровПечати = "ВедомостьЗП_ВедомостьПеречисленияНаКартСчета";
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВедомостьЗП.ПФ_MXL_ВедомостьПеречисленияНаКартСчета");
			
			Запрос = Новый Запрос();
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ТаблицаДокумента.Дата КАК ДатаДокумента,
				|	ТаблицаДокумента.Номер КАК НомерДокумента,
				|	ТаблицаДокумента.Организация,
				|	ТаблицаДокумента.ПериодРегистрации,
				|	ТаблицаДокумента.Зарплата.(
				|		НомерСтроки КАК НомерСтроки,
				|		ФизЛицо,
				|		СуммаКВыплате КАК Сумма,
				|		НомерЛицевогоСчета,
				|		0 КАК СуммаНеРезиденты,
				|		СуммаКВыплате КАК СуммаРезиденты
				|	)
				|ИЗ
				|	Документ.ВедомостьЗП КАК ТаблицаДокумента
				|ГДЕ
				|	ТаблицаДокумента.Ссылка = &ТекущийДокумент
				|
				|УПОРЯДОЧИТЬ ПО
				|	НомерСтроки";
			Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
			
			Шапка = Запрос.Выполнить().Выбрать();
			Шапка.Следующий();
			
			ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
			
			ДанныеПечати = Новый Структура;
			
			ДанныеПечати.Вставить("Организация", Шапка.Организация);
			ДанныеПечати.Вставить("ДатаДокумента", Шапка.ДатаДокумента);
			ДанныеПечати.Вставить("НомерДокумента", Шапка.НомерДокумента);
			ДанныеПечати.Вставить("ПериодРегистрации", Шапка.ПериодРегистрации);
			
			ВременнаяТаблицаЗарплата = Шапка.Зарплата.Выгрузить();
			// Итоги
			ДанныеПечати.Вставить("Сумма", ВременнаяТаблицаЗарплата.Итог("Сумма"));
			ДанныеПечати.Вставить("СуммаРезиденты", ВременнаяТаблицаЗарплата.Итог("СуммаРезиденты"));
			ДанныеПечати.Вставить("СуммаНеРезиденты", ВременнаяТаблицаЗарплата.Итог("СуммаНеРезиденты"));

			ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Сумма));

			МассивОбластейМакета = Новый Массив;
			МассивОбластейМакета.Добавить("Заголовок");
			МассивОбластейМакета.Добавить("ШапкаТаблицы");
			МассивОбластейМакета.Добавить("Строка");
			МассивОбластейМакета.Добавить("Подвал");
			
			Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
				ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
				Если ИмяОбласти <> "Строка" Тогда
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				Иначе
					Для Каждого СтрокаТаблицы Из ВременнаяТаблицаЗарплата Цикл
						ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
						ТабличныйДокумент.Вывести(ОбластьМакета);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ИмяМакета = "ПлатежнаяВедомость" Тогда  
			ТабличныйДокумент.КлючПараметровПечати = "ВедомостьЗП_ПлатежнаяВедомость";     
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВедомостьЗП.ПФ_MXL_ПлатежнаяВедомость");
			
			Запрос = Новый Запрос();
			Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
			Запрос.УстановитьПараметр("ВалютаДокумента", Константы.ВалютаРегламентированногоУчета.Получить());
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВедомостьЗП.Дата КАК ДатаДокумента,
			|	ВедомостьЗП.Подразделение КАК Подразделение,
			|	ВедомостьЗП.ПериодРегистрации КАК ПериодРегистрации,
			|	ВедомостьЗП.Номер,
			|	ВедомостьЗП.Организация.Префикс КАК Префикс,
			|	&ВалютаДокумента,
			|	ВедомостьЗП.Организация.НаименованиеПолное,
			|	ВедомостьЗП.Организация,
			|	ВедомостьЗП.Организация.КодПоОКПО,
			|	ВедомостьЗП.БанковскийСчет,
			|	ВедомостьЗП.БанковскийСчет.Банк.КоррСчет
			|ИЗ
			|	Документ.ВедомостьЗП КАК ВедомостьЗП
			|ГДЕ
			|	ВедомостьЗП.Ссылка = &ТекущийДокумент";
			
			Шапка = Запрос.Выполнить().Выбрать();
			Шапка.Следующий();
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ТекущийДокумент",   ТекущийДокумент);
			Запрос.УстановитьПараметр("ПериодРегистрации", КонецМесяца(ТекущийДокумент.ПериодРегистрации));
			Запрос.УстановитьПараметр("Осн", НСтр("ru = 'Осн.'"));
			Запрос.УстановитьПараметр("Совм", НСтр("ru = 'Совм.'"));
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ВедомостьНаВыплатуЗарплатыЗарплата.ФизЛицо.Код КАК ТабельныйНомер,
			|	&Осн КАК ХарактерРаботы,
			|	СУММА(ВедомостьНаВыплатуЗарплатыЗарплата.СуммаКВыплате) КАК Сумма,
			|	ФИОФизЛицСрезПоследних.Фамилия,
			|	ФИОФизЛицСрезПоследних.Имя,
			|	ФИОФизЛицСрезПоследних.Отчество,
			|	ФИОФизЛицСрезПоследних.Период,
			|	ВедомостьНаВыплатуЗарплатыЗарплата.ФизЛицо КАК Физлицо,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия, """") <> """"
			|			ТОГДА ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество
			|		ИНАЧЕ ВедомостьНаВыплатуЗарплатыЗарплата.ФизЛицо.Наименование
			|	КОНЕЦ КАК СотрудникПредставление
			|ИЗ
			|	Документ.ВедомостьЗП.Зарплата КАК ВедомостьНаВыплатуЗарплатыЗарплата
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&ПериодРегистрации, ) КАК ФИОФизЛицСрезПоследних
			|		ПО ВедомостьНаВыплатуЗарплатыЗарплата.ФизЛицо = ФИОФизЛицСрезПоследних.ФизЛицо
			|ГДЕ
			|	ВедомостьНаВыплатуЗарплатыЗарплата.Ссылка = &ТекущийДокумент
			|
			|СГРУППИРОВАТЬ ПО
			|	ФИОФизЛицСрезПоследних.Имя,
			|	ФИОФизЛицСрезПоследних.Отчество,
			|	ФИОФизЛицСрезПоследних.Фамилия,
			|	ВедомостьНаВыплатуЗарплатыЗарплата.ФизЛицо,
			|	ФИОФизЛицСрезПоследних.Период,
			|	ВедомостьНаВыплатуЗарплатыЗарплата.ФизЛицо.Код,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия, """") <> """"
			|			ТОГДА ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество
			|		ИНАЧЕ ВедомостьНаВыплатуЗарплатыЗарплата.ФизЛицо.Наименование
			|	КОНЕЦ
			|
			|УПОРЯДОЧИТЬ ПО
			|	СотрудникПредставление";
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			ОбластьШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
			ОбластьШапка          = Макет.ПолучитьОбласть("Шапка");
			ОбластьДетали         = Макет.ПолучитьОбласть("Детали");
			ОбластьПодвал         = Макет.ПолучитьОбласть("Подвал");
			
			НомерДокумента = Шапка.Номер;
			
			ОбластьШапкаДокумента.Параметры.ОрганизацияПоОКПО = Шапка.ОрганизацияКодПоОКПО;
			ОбластьШапкаДокумента.Параметры.ОрганизацияКоррСчет = Шапка.БанковскийСчетБанкКоррСчет;
			ОбластьШапкаДокумента.Параметры.НазваниеОрганизации = Шапка.ОрганизацияНаименованиеПолное;
			ОбластьШапкаДокумента.Параметры.Подразделение = Шапка.Подразделение;
			ОбластьШапкаДокумента.Параметры.СуммаДокПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ТекущийДокумент.Зарплата.Итог("СуммаКВыплате"),Шапка.ВалютаДокумента);
			СуммаКВыплате = ТекущийДокумент.Зарплата.Итог("СуммаКВыплате"); 
			ОбластьШапкаДокумента.Параметры.СуммаДок = СуммаКВыплате;
			ОбластьШапкаДокумента.Параметры.Валюта = Шапка.ВалютаДокумента;
			ОбластьШапкаДокумента.Параметры.НомерДок = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(НомерДокумента));	//НомерДокумента;
			ОбластьШапкаДокумента.Параметры.ДатаДок = Шапка.ДатаДокумента;
			ОбластьШапкаДокумента.Параметры.ОтчетныйПериодС = Шапка.ПериодРегистрации;
			ОбластьШапкаДокумента.Параметры.ОтчетныйПериодПо = КонецМесяца(Шапка.ПериодРегистрации);
			 
			Руководители = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.ДатаДокумента);
			ОбластьШапкаДокумента.Параметры.Заполнить(Руководители);
			
			ТабличныйДокумент.Вывести(ОбластьШапкаДокумента);
			
			ОбластьШапка.Параметры.НадписьСумма = "Сумма, " + (Шапка.ВалютаДокумента);
			ТабличныйДокумент.Вывести(ОбластьШапка);
		 
			НПП = 0;
			Пока Выборка.Следующий() Цикл
				НПП = НПП + 1;
				ОбластьДетали.Параметры.НомерСтроки = НПП;
				ОбластьДетали.Параметры.Заполнить(Выборка);
				Если ЗначениеЗаполнено(Выборка.Фамилия) Тогда
					ФИО = БухгалтерскийУчетСервер.ПолучитьФамилиюИмяОтчество(Выборка.Фамилия, Выборка.Имя, Выборка.Отчество, Истина);
					ОбластьДетали.Параметры.ФизЛицо = ?(ЗначениеЗаполнено(ФИО), ФИО, Выборка.Физлицо);
				КонецЕсли; 
				ТабличныйДокумент.Вывести(ОбластьДетали);
			КонецЦикла;
			
			ОбластьПодвал.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаКВыплате,Шапка.ВалютаДокумента);
			ЦЧ = СтрЗаменить(Цел(СуммаКВыплате), Символы.НПП,"");
			ДЧ = (СуммаКВыплате - ЦЧ)*100; 
			ОбластьПодвал.Параметры.ЦЧ = ЦЧ;
			ОбластьПодвал.Параметры.ДЧ = ДЧ;
			ТабличныйДокумент.Вывести(ОбластьПодвал);
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
	КонецЦикла;
	
	Если НЕ Ошибки = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;	
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Добавление дополнительных параметров
	БухгалтерскиеОтчетыКлиентСервер.ЗаполнитьДополнительныеПараметрыПечати(ТабличныйДокумент);
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ВедомостьПеречисленияНаКартСчета") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
			"ВедомостьПеречисленияНаКартСчета", 
			"Ведомость перечисления на карт счета", 
			ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "ВедомостьПеречисленияНаКартСчета"));
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПлатежнаяВедомость") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
			"ПлатежнаяВедомость", 
			"Платежная ведомость", 
			ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "ПлатежнаяВедомость"));
	КонецЕсли;

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПлатежнаяВедомость";
	КомандаПечати.Представление = НСтр("ru = 'Платежная ведомость'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;

	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ВедомостьПеречисленияНаКартСчета";
	КомандаПечати.Представление = НСтр("ru = 'Ведомость перечисления на карт счета'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 2;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
