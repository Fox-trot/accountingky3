﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаПрочийРасход.СчетРасчетов КАК СчетДт,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаПрочийРасход.Субконто1 КАК СубконтоДт1,
		|	ВременнаяТаблицаПрочийРасход.Субконто2 КАК СубконтоДт2,
		|	ВременнаяТаблицаПрочийРасход.Субконто3 КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК СубконтоКт1,
		|	ВременнаяТаблицаПрочийРасход.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаПрочийРасход.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаПрочийРасход.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаПрочийРасход.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	&Содержание КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочийРасход КАК ВременнаяТаблицаПрочийРасход
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаПрочийРасход.СуммаПлатежа = 0";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Списание денежных средств'")); 
	РезультатЗапроса = Запрос.Выполнить();		
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДенежныеСредства()

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ДвиженияДенежныхСредств.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДвиженияДенежныхСредств(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаПрочийРасход.СтатьяДвиженияДенежныхСредств КАК Статья,
		|	ВременнаяТаблицаПрочийРасход.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочийРасход КАК ВременнаяТаблицаПрочийРасход
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаПрочийРасход.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)";
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвиженияДенежныхСредств", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлатежныйОрдерСписаниеДС.Номер,
		|	ПлатежныйОрдерСписаниеДС.Дата,
		|	ПлатежныйОрдерСписаниеДС.Организация,
		|	ПлатежныйОрдерСписаниеДС.БанковскийСчет,
		|	ПлатежныйОрдерСписаниеДС.ВалютаДокумента,
		|	ПлатежныйОрдерСписаниеДС.Курс,
		|	ПлатежныйОрдерСписаниеДС.Кратность,
		|	ПлатежныйОрдерСписаниеДС.СуммаДокумента,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПлатежныйОрдерСписаниеДС КАК ПлатежныйОрдерСписаниеДС
		|ГДЕ
		|	ПлатежныйОрдерСписаниеДС.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлатежныйОрдерСписаниеДСПрочиеПлатежи.СтатьяДвиженияДенежныхСредств,
		|	ПлатежныйОрдерСписаниеДСПрочиеПлатежи.СуммаПлатежа,
		|	ПлатежныйОрдерСписаниеДСПрочиеПлатежи.СчетРасчетов,
		|	ПлатежныйОрдерСписаниеДСПрочиеПлатежи.Субконто1,
		|	ПлатежныйОрдерСписаниеДСПрочиеПлатежи.Субконто2,
		|	ПлатежныйОрдерСписаниеДСПрочиеПлатежи.Субконто3
		|ПОМЕСТИТЬ ВременнаяТаблицаПрочийРасход
		|ИЗ
		|	Документ.ПлатежныйОрдерСписаниеДС.ПрочиеПлатежи КАК ПлатежныйОрдерСписаниеДСПрочиеПлатежи
		|ГДЕ
		|	ПлатежныйОрдерСписаниеДСПрочиеПлатежи.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(СтруктураДополнительныеСвойства);
	СформироватьТаблицаДвиженияДенежныхСредств(СтруктураДополнительныеСвойства);
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

#КонецЕсли
