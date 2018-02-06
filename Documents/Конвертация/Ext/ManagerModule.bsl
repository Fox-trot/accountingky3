﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата КАК Период,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.СчетПрихода КАК СчетДт,
		|	ТаблицаДокумента.СчетРасхода КАК СчетКт,
		|	ТаблицаДокумента.ПриходРасчетныйСчет КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ТаблицаДокумента.РасходРасчетныйСчет КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ТаблицаДокумента.ВалютаПрихода = ТаблицаДокумента.ВалютаРегламентированногоУчета
		|				И ТаблицаДокумента.ВалютаРасхода <> ТаблицаДокумента.ВалютаРегламентированногоУчета
		|			ТОГДА ТаблицаДокумента.СуммаПрихода
		|		КОГДА ТаблицаДокумента.ВалютаПрихода <> ТаблицаДокумента.ВалютаРегламентированногоУчета
		|				И ТаблицаДокумента.ВалютаРасхода = ТаблицаДокумента.ВалютаРегламентированногоУчета
		|			ТОГДА ТаблицаДокумента.СуммаРасхода
		|		КОГДА ТаблицаДокумента.ВалютаПрихода <> ТаблицаДокумента.ВалютаРегламентированногоУчета
		|				И ТаблицаДокумента.ВалютаРасхода <> ТаблицаДокумента.ВалютаРегламентированногоУчета
		|			ТОГДА ТаблицаДокумента.СуммаУчетная
		|		ИНАЧЕ ТаблицаДокумента.СуммаРасхода
		|	КОНЕЦ КАК Сумма,
		|	ТаблицаДокумента.ВалютаПрихода КАК ВалютаДт,
		|	ТаблицаДокумента.ВалютаРасхода КАК ВалютаКт,
		|	ТаблицаДокумента.СуммаПрихода КАК ВалютнаяСуммаДт,
		|	ТаблицаДокумента.СуммаРасхода КАК ВалютнаяСуммаКт,
		|	ВЫБОР
		|		КОГДА (ВЫРАЗИТЬ(ТаблицаДокумента.Комментарий КАК СТРОКА(1000))) = """"
		|			ТОГДА ""Конвертация""
		|		ИНАЧЕ ""Конвертация - "" + (ВЫРАЗИТЬ(ТаблицаДокумента.Комментарий КАК СТРОКА(1000)))
		|	КОНЕЦ КАК Содержание
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента";			
	РезультатЗапроса = Запрос.Выполнить();		
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
	// Подготовка таблицы для расчета операционных курсовых разниц.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата КАК Период,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ПриходРасчетныйСчет КАК КассаБанковскийСчетПриход,
		|	ТаблицаДокумента.РасходРасчетныйСчет КАК КассаБанковскийСчетРасход,
		|	ТаблицаДокумента.СчетРасхода КАК СчетРасчетов,
		|	ТаблицаДокумента.СчетПрихода КАК ДенежныйСчет,
		|	ТаблицаДокумента.ВалютаПрихода КАК ВалютаДокумента,
		|	ТаблицаДокумента.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ТаблицаДокумента.ВалютаРасхода КАК ВалютаРасчетов,
		|	ТаблицаДокумента.КурсПрихода КАК КурсДокумента,
		|	ВременнаяТаблицаКурсыВалют.Кратность КАК КратностьДокумента
		|ПОМЕСТИТЬ ВременнаяТаблицаРеквизиты
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалют КАК ВременнаяТаблицаКурсыВалют
		|		ПО ТаблицаДокумента.ВалютаПрихода = ВременнаяТаблицаКурсыВалют.Валюта
		|ГДЕ
		|	НЕ ТаблицаДокумента.ВалютаРасхода = ТаблицаДокумента.ВалютаПрихода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.СуммаПрихода КАК СуммаПлатежа,
		|	ТаблицаДокумента.СуммаРасхода КАК СуммаВзаиморасчетов,
		|	ВременнаяТаблицаКурсыВалют.Курс КАК КурсВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаКурсыВалют.Кратность КАК КратностьВзаиморасчетовПоНацБанку
		|ПОМЕСТИТЬ ВременнаяТаблицаСуммы
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалют КАК ВременнаяТаблицаКурсыВалют
		|		ПО ВЫБОР 
		|				КОГДА ТаблицаДокумента.ВалютаРасхода = ТаблицаДокумента.ВалютаРегламентированногоУчета
		|					ТОГДА ТаблицаДокумента.ВалютаПрихода = ВременнаяТаблицаКурсыВалют.Валюта
		|				ИНАЧЕ ТаблицаДокумента.ВалютаРасхода = ВременнаяТаблицаКурсыВалют.Валюта
		|		   КОНЕЦ
		|ГДЕ
		|	НЕ ТаблицаДокумента.ВалютаРасхода = ТаблицаДокумента.ВалютаПрихода
		|	И НЕ ТаблицаДокумента.КурсОбмена = ВременнаяТаблицаКурсыВалют.Курс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаРеквизиты.Период,
		|	ТаблицаРеквизиты.Организация,
		|	ТаблицаРеквизиты.КассаБанковскийСчетПриход,
		|	ТаблицаРеквизиты.КассаБанковскийСчетРасход,
		|	ТаблицаРеквизиты.СчетРасчетов,
		|	ТаблицаРеквизиты.ДенежныйСчет,
		|	ТаблицаРеквизиты.ВалютаДокумента,
		|	ТаблицаРеквизиты.ВалютаРегламентированногоУчета,
		|	ТаблицаРеквизиты.ВалютаРасчетов,
		|	ТаблицаРеквизиты.КурсДокумента,
		|	ТаблицаРеквизиты.КратностьДокумента,
		|	ТаблицаСуммы.СуммаПлатежа,
		|	ТаблицаСуммы.СуммаВзаиморасчетов,
		|	ТаблицаСуммы.КурсВзаиморасчетовПоНацБанку,
		|	ТаблицаСуммы.КратностьВзаиморасчетовПоНацБанку
		|ИЗ
		|	ВременнаяТаблицаРеквизиты КАК ТаблицаРеквизиты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСуммы КАК ТаблицаСуммы
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&СчитатьОперационныеКурсовыеРазницы";
	Запрос.УстановитьПараметр("СчитатьОперационныеКурсовыеРазницы", СтруктураДополнительныеСвойства.УчетнаяПолитика.СчитатьОперационныеКурсовыеРазницы);
	РезультатЗапроса = Запрос.Выполнить();

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДанных", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаДенежныеСредства()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Конвертация.Ссылка,
		|	Конвертация.ВерсияДанных,
		|	Конвертация.ПометкаУдаления,
		|	Конвертация.Номер,
		|	Конвертация.Дата,
		|	Конвертация.Проведен,
		|	Конвертация.Организация,
		|	Конвертация.Комментарий,
		|	Конвертация.Автор,
		|	Конвертация.СуммаКР,
		|	Конвертация.СуммаРасхода,
		|	Конвертация.СуммаПрихода,
		|	Конвертация.ВалютаРасхода,
		|	Конвертация.ВалютаПрихода,
		|	Конвертация.КурсРасхода,
		|	Конвертация.КурсПрихода,
		|	Конвертация.СчетРасхода,
		|	Конвертация.СчетПрихода,
		|	Конвертация.КурсОбмена,
		|	Конвертация.ПриходРасчетныйСчет,
		|	Конвертация.РасходРасчетныйСчет,
		|	Конвертация.КросскурсНБКР,
		|	Конвертация.ПрямойКурс,
		|	Конвертация.СуммаУчетная,
		|	&ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	Документ.Конвертация КАК Конвертация
		|ГДЕ
		|	Конвертация.Ссылка = &Ссылка				
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
		|	КурсыВалютСрезПоследних.Курс КАК Курс,
		|	КурсыВалютСрезПоследних.Кратность КАК Кратность
		|ПОМЕСТИТЬ ВременнаяТаблицаКурсыВалют
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта В (&МассивВалют)) КАК КурсыВалютСрезПоследних";				
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);	
	Запрос.УстановитьПараметр("Период", СтруктураДополнительныеСвойства.ДляПроведения.Дата);	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	
	МассивВалют = Новый Массив();
	МассивВалют.Добавить(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаПрихода);	
	МассивВалют.Добавить(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасхода);
	Запрос.УстановитьПараметр("МассивВалют", МассивВалют);
	
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

Функция ПечатьЗаявленияНаКонвертацию(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Конвертация.Ссылка,
	|	Конвертация.Номер,
	|	Конвертация.Дата,
	|	Конвертация.Организация,
	|	Конвертация.Организация.НаименованиеПолное,
	|	ВЫРАЗИТЬ(Конвертация.СуммаРасхода КАК ЧИСЛО(15, 2)) КАК СуммаРасхода,
	|	ВЫРАЗИТЬ(Конвертация.СуммаПрихода КАК ЧИСЛО(15, 2)) КАК СуммаПрихода,
	|	Конвертация.ВалютаРасхода.Наименование,
	|	Конвертация.ВалютаПрихода.Наименование,
	|	Конвертация.ПриходРасчетныйСчет.НомерСчета КАК НомерСчетаПрихода,
	|	Конвертация.ПриходРасчетныйСчет.Банк.Наименование КАК БанкПриходаНаименование,
	|	Конвертация.РасходРасчетныйСчет.НомерСчета КАК НомерСчетаРасхода,
	|	Конвертация.РасходРасчетныйСчет.Банк.Наименование КАК БанкРасходаНаименование,
	|	Конвертация.КурсОбмена,
	|	Конвертация.Организация.КодПоОКПО,
	|	Конвертация.РасходРасчетныйСчет.Банк.ПечатнаяФормаБанка КАК ПечатнаяФормаБанкаРасхода,
	|	Конвертация.ВалютаРасхода,
	|	Конвертация.ВалютаПрихода
	|ИЗ
	|	Документ.Конвертация КАК Конвертация
	|ГДЕ
	|	Конвертация.Ссылка В(&МассивОбъектов)";	
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаДок=Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Конвертация_ЗаявлениеНаКонвертацию";
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаДок.Следующий() Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Конвертация.ПФ_MXL_ЗаявлениеНаКонвертацию");
		
		Если ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.БанкКыргызстан  Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаБанкКыргызстан");
		ИначеЕсли ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.БакайБанк Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаБанкБакай");
		ИначеЕсли ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.АйылБанк Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаБанкАйыл");
		ИначеЕсли ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.ДосКредобанк Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаБанкДоскредобанк");
		Иначе
			Продолжить;
		КонецЕсли;
				
		ОбластьМакета.Параметры.Заполнить(ВыборкаДок);
		ОбластьМакета.Параметры.Дата		 			= Формат(ВыборкаДок.Дата, ?(ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.БанкКыргызстан ИЛИ
																					ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.БакайБанк,
																					"ДЛФ=D",
																					"ДЛФ=DD"));
		ОбластьМакета.Параметры.СуммаРасхода 			= Формат(ВыборкаДок.СуммаРасхода, 	"ЧДЦ=2");
		ОбластьМакета.Параметры.СуммаПрихода 			= Формат(ВыборкаДок.СуммаПрихода, 	"ЧДЦ=2");
		
		Если СтрНайти(ВыборкаДок.БанкРасходаНаименование, "Дос-Кредо") > 0 Тогда		
			ОбластьМакета.Параметры.ЮридическийАдресОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ВыборкаДок.Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
			ОбластьМакета.Параметры.ТелефонОрганизации 			= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ВыборкаДок.Организация, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);		
			Руководители = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(ВыборкаДок.Организация, ВыборкаДок.Дата);
			ОбластьМакета.Параметры.ФИО 		= Руководители.Руководитель;
			ОбластьМакета.Параметры.Должность 	= Руководители.РуководительДолжность;
		Иначе
			ОбластьМакета.Параметры.СуммаРасходаПрописью 	= БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ВыборкаДок.СуммаРасхода, ВыборкаДок.ВалютаРасхода);
			ОбластьМакета.Параметры.СуммаПриходаПрописью 	= БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ВыборкаДок.СуммаПрихода, ВыборкаДок.ВалютаПрихода);			
		КонецЕсли;
		
		Если ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.БанкКыргызстан ИЛИ ВыборкаДок.ПечатнаяФормаБанкаРасхода = Перечисления.ПечатныеФормыБанков.БакайБанк Тогда
			ОбластьМакета.Параметры.Номер 					= ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДок.Номер);
		КонецЕсли;
				
		ТабличныйДокумент.Вывести(ОбластьМакета);
						
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДок.Ссылка);
		
	КонецЦикла;//ВыборкаДок.Следующий()
	
	Возврат ТабличныйДокумент;
		
КонецФункции

Функция ПечатьКонвертации(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Конвертация.Ссылка,
	|	Конвертация.Номер,
	|	Конвертация.Дата,
	|	Конвертация.СчетПрихода КАК СчетП,
	|	Конвертация.СчетРасхода КАК СчетР,
	|	Конвертация.ПриходРасчетныйСчет КАК РСчетП,
	|	Конвертация.РасходРасчетныйСчет КАК РСчетР,
	|	ВЫРАЗИТЬ(Конвертация.СуммаПрихода КАК ЧИСЛО(15, 2)) КАК СуммаП,
	|	ВЫРАЗИТЬ(Конвертация.СуммаРасхода КАК ЧИСЛО(15, 2)) КАК СуммаР,
	|	Конвертация.ВалютаРасхода.Наименование КАК ВалютаР,
	|	Конвертация.ВалютаПрихода.Наименование КАК ВалютаП,
	|	ВЫРАЗИТЬ(Конвертация.СуммаПрихода * Конвертация.КурсПрихода КАК ЧИСЛО(15, 2)) КАК СуммаНВП,
	|	ВЫРАЗИТЬ(Конвертация.СуммаРасхода * Конвертация.КурсРасхода КАК ЧИСЛО(15, 2)) КАК СуммаНВР,
	|	Конвертация.КурсОбмена КАК Курс,
	|	Конвертация.Комментарий
	|ИЗ
	|	Документ.Конвертация КАК Конвертация
	|ГДЕ
	|	Конвертация.Ссылка В(&МассивОбъектов)";	
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Конвертация_ПечатьКонвертации";
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Конвертация.ПФ_MXL_ПечатьКонвертация");
		
		Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер);
		Дата  = Формат(Выборка.Дата, "ДФ=dd.MM.yyyy");
		
		ОперационнаяКР = Окр(Выборка.СуммаНВП - Выборка.СуммаНВР, 2);
		
		ДанныеПечати = Новый Структура();
		ДанныеПечати.Вставить("Заголовок", СтрШаблон(НСтр("ru = 'Конвертация денежных средств № %1 от %2'"), Номер, Дата));
		Если ОперационнаяКР > 0 Тогда
			ДанныеПечати.Вставить("ДУ", СтрШаблон(НСтр("ru = 'Доход: %1'"), Формат(ОперационнаяКР, "ЧЦ=15; ЧДЦ=2")));
		Иначе
			ДанныеПечати.Вставить("ДУ", СтрШаблон(НСтр("ru = 'Убыток: %1'"), Формат(ОперационнаяКР * -1, "ЧЦ=15; ЧДЦ=2")));
		КонецЕсли;	
		
		// Области
		МассивОбластейМакета = Новый Массив; 
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("Организация");
		МассивОбластейМакета.Добавить("Строка");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Выборка);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
						
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьЗаявленияНаКонвертацию") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ПечатьЗаявленияНаКонвертацию",
		НСтр("ru = 'Печать заявления на конвертацию'"),
		ПечатьЗаявленияНаКонвертацию(МассивОбъектов, ОбъектыПечати),,
		"Документ.Конвертация.ПФ_MXL_ЗаявлениеНаКонвертацию");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьКонвертация") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ПечатьКонвертация",
		НСтр("ru = 'Конвертация'"),
		ПечатьКонвертации(МассивОбъектов, ОбъектыПечати),,
		"Документ.Конвертация.ПФ_MXL_ПечатьКонвертация");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
	//КомандаПечати = КомандыПечати.Добавить();
	//КомандаПечати.Идентификатор = "ПечатьЗаявленияНаКонвертацию";
	//КомандаПечати.Представление = НСтр("ru = 'Печать заявления на конвертацию'");
	//КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	//КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	//КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	//КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПечатьКонвертация";
	КомандаПечати.Представление = НСтр("ru = 'Конвертация'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
