﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСведенияОРаботеСверхурочно(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.ДатаНачала КАК ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончания КАК ДатаОкончания,
		|	ТаблицаДокумента.ВидРасчета КАК ВидРасчета,
		|	ТаблицаДокумента.Валюта КАК Валюта,
		|	ТаблицаДокумента.ГрафикРаботы КАК ГрафикРаботы,
		|	ТаблицаДокумента.Подразделение КАК Подразделение,
		|	ТаблицаДокумента.Часов КАК Часов,
		|	ТаблицаДокумента.РазмерОсновногоВидаРасчета КАК РазмерОсновногоВидаРасчета
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ТаблицаДокумента
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(&Дата, ) КАК СотрудникиСрезПоследних
		|			ПО ТаблицаДокумента.ФизЛицо = СотрудникиСрезПоследних.ФизЛицо
		|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("Дата", СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСведенияОРаботеСверхурочно", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеНачисленияИУдержания()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Организация КАК Организация
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.РаботаВВыходныеИПраздничныеДни КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.ВидРасчета КАК ВидРасчета,
		|	ТаблицаДокумента.Валюта КАК Валюта,
		|	ТаблицаДокумента.ГрафикРаботы КАК ГрафикРаботы,
		|	ТаблицаДокумента.Подразделение КАК Подразделение,
		|	ТаблицаДокумента.Часов КАК Часов,
		|	ТаблицаДокумента.ДатаНачала КАК ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончания КАК ДатаОкончания,
		|	ТаблицаДокумента.РазмерОсновногоВидаРасчета КАК РазмерОсновногоВидаРасчета
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
		|ИЗ
		|	Документ.РаботаВВыходныеИПраздничныеДни.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаСведенияОРаботеСверхурочно(ДокументСсылка, СтруктураДополнительныеСвойства);
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

Функция ПечатнаяФормаПриказОРаботеВВыходнойИПраздничныйДень(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	РаботаВВыходныеИПраздничныеДни.Ссылка,
		|	РаботаВВыходныеИПраздничныеДни.Номер КАК НомерДокумента,
		|	РаботаВВыходныеИПраздничныеДни.Дата КАК ДатаДокумента,
		|	РаботаВВыходныеИПраздничныеДни.Организация,
		|	РаботаВВыходныеИПраздничныеДни.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	РаботаВВыходныеИПраздничныеДни.Основание,
		|	РаботаВВыходныеИПраздничныеДни.Причина,
		|	РаботаВВыходныеИПраздничныеДни.Сотрудники.(
		|		Ссылка,
		|		НомерСтроки,
		|		ФизЛицо,
		|		ФизЛицо.Наименование,
		|		ФизЛицо.Код КАК ТабельныйНомер
		|	),
		|	РаботаВВыходныеИПраздничныеДни.СтатьяТрудовогоКодекса
		|ИЗ
		|	Документ.РаботаВВыходныеИПраздничныеДни КАК РаботаВВыходныеИПраздничныеДни
		|ГДЕ
		|	РаботаВВыходныеИПраздничныеДни.Ссылка В(&СписокДокументов)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "РаботаВВыходныеИПраздничныеДни_ПриказОРаботеВВыходной";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РаботаВВыходныеИПраздничныеДни.ПФ_MXL_ПриказОРаботеВВыходной");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("НомерДокумента", Шапка.НомерДокумента);
		ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.ДатаДокумента, "ДЛФ=D"));
		ДанныеПечати.Вставить("Основание", Шапка.Основание);
		ДанныеПечати.Вставить("Причина", Шапка.Причина);
		ДанныеПечати.Вставить("СтатьяТрудовогоКодекса", Шапка.СтатьяТрудовогоКодекса);
		Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.ДатаДокумента);
		Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
			ДанныеПечати.Вставить("ДолжностьРуководителя", Структура.РуководительДолжность);
			ДанныеПечати.Вставить("ФИОРуководителя", Структура.Руководитель);
		КонецЕсли;	
		
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Шапка");
		МассивОбластейМакета.Добавить("Сотрудник");
		МассивОбластейМакета.Добавить("Подвал");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если НЕ ИмяОбласти = "Сотрудник" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Сотрудник" Тогда  
				
				ВыборкаПоСотрудникам = Шапка.Сотрудники.Выбрать();
				
				Пока ВыборкаПоСотрудникам.Следующий() Цикл 
					СведенияОФизЛице = БухгалтерскийУчетСервер.ПолучитьСведенияОФизЛице(Шапка.Организация, ВыборкаПоСотрудникам.ФизЛицо, Шапка.ДатаДокумента); 
					
					Структура = Новый Структура();
					Структура.Вставить("ДанныеСотрудника", Строка(ВыборкаПоСотрудникам.ТабельныйНомер) 
											+ " " + СведенияОФизЛице.ФИО + " - " + СведенияОФизЛице.Должность);
					
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Структура); 
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;	
			КонецЕсли;
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции	

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

	// печать Приказ о сверхурочной работе
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОРаботеВВыходнойИПраздничныйДень") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ПриказОРаботеВВыходнойИПраздничныйДень", 
			НСтр("ru = 'Приказ о работе в выходной и праздничный день'"), 
			ПечатнаяФормаПриказОРаботеВВыходнойИПраздничныйДень(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.РаботаВВыходныеИПраздничныеДни.ПФ_MXL_ПриказОРаботеВВыходной");
	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о сверхурочной работе
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказОРаботеВВыходнойИПраздничныйДень";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о работе в выходной и праздничный день'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 10;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
