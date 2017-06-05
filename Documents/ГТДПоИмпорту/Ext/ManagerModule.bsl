﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период КАК Период,
	|	ВременнаяТаблицаШапка.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению) КАК СчетДт,
	|	ВременнаяТаблицаШапка.СчетРасчетовСКонтрагентом КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоКт1,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	ВременнаяТаблицаТовары.СуммаНДС КАК Сумма,
	|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
	|	ВременнаяТаблицаТовары.СуммаНДС КАК ВалютнаяСуммаДт,
	|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
	|	ВременнаяТаблицаТовары.СуммаНДС КАК ВалютнаяСуммаКт,
	|	""НДС по импорту"" КАК Содержание,
	|	0 КАК КоличествоДт,
	|	0 КАК КоличествоКт
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
	|ГДЕ
	|	ВременнаяТаблицаТовары.СуммаНДС <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаТовары.СчетУчета,
	|	ВременнаяТаблицаШапка.СчетРасчетовСКонтрагентом,
	|	ВременнаяТаблицаТовары.Номенклатура,
	|	ВременнаяТаблицаШапка.Склад,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаШапка.Контрагент,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаТовары.СуммаСопровождения,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаСопровождения,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаСопровождения,
	|	""Таможенное сопровождение"",
	|	0,
	|	0
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
	|ГДЕ
	|	ВременнаяТаблицаТовары.СуммаСопровождения <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаТовары.СчетУчета,
	|	ВременнаяТаблицаШапка.СчетРасчетовСКонтрагентом,
	|	ВременнаяТаблицаТовары.Номенклатура,
	|	ВременнаяТаблицаШапка.Склад,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаШапка.Контрагент,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаТовары.СуммаПошлины,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаПошлины,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаПошлины,
	|	""Таможенная пошлина"",
	|	0,
	|	0
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
	|ГДЕ
	|	ВременнаяТаблицаТовары.СуммаПошлины <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаТовары.СчетУчета,
	|	ВременнаяТаблицаШапка.СчетРасчетовСКонтрагентом,
	|	ВременнаяТаблицаТовары.Номенклатура,
	|	ВременнаяТаблицаШапка.Склад,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаШапка.Контрагент,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаТовары.СуммаТаможенногоСбора,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаТаможенногоСбора,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаТаможенногоСбора,
	|	""Таможенный сбор"",
	|	0,
	|	0
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
	|ГДЕ
	|	ВременнаяТаблицаТовары.СуммаТаможенногоСбора <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаТовары.СчетУчета,
	|	ВременнаяТаблицаШапка.СчетРасчетовСКонтрагентом,
	|	ВременнаяТаблицаТовары.Номенклатура,
	|	ВременнаяТаблицаШапка.Склад,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаШапка.Контрагент,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
	|	НЕОПРЕДЕЛЕНО,
	|	ВременнаяТаблицаТовары.СуммаАкциза,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаАкциза,
	|	ВременнаяТаблицаШапка.ВалютаДокумента,
	|	ВременнаяТаблицаТовары.СуммаАкциза,
	|	""Акциз"",
	|	0,
	|	0
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
	|ГДЕ
	|	ВременнаяТаблицаТовары.СуммаАкциза <> 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

Процедура СформироватьТаблицаНДСГТДИмпорт(ДокументСсылка, СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаТовары.Номенклатура,
	|	ВременнаяТаблицаТовары.ЗачетНДС КАК ЗачетНДС,	
	|	ВременнаяТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ВременнаяТаблицаТовары.БазаНДС КАК СуммаСебестоимости
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
	|ГДЕ
	|	НЕ ВременнаяТаблицаТовары.ДокументПоступления.Контрагент.СтранаРезидентства = ЗНАЧЕНИЕ(Справочник.СтраныМира.Киргизия)
	|	И НЕ ВременнаяТаблицаТовары.ДокументПоступления.Контрагент.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)";
	
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНДСГТДИмпорт", РезультатЗапроса.Выгрузить());
		
КонецПроцедуры 

Процедура СформироватьТаблицаНДСНаИмпорт(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.ДокументПоступления КАК Документ.ПоступлениеТоваровУслуг).ПоказательИмпорта КАК ПоказательИмпорта,
	|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.ДокументПоступления КАК Документ.ПоступлениеТоваровУслуг).ИмпортОсвобожденныйОтНДС КАК ИмпортОСвобожденныйОтНДС,
	|	ВременнаяТаблицаШапка.СтавкаНДС,
	|	ВременнаяТаблицаТовары.БазаНДС КАК Сумма,
	|	ВременнаяТаблицаТовары.СуммаНДС,
	|	ВременнаяТаблицаТовары.СуммаАкциза КАК СуммаАкциз
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНДСНаИмпорт", РезультатЗапроса.Выгрузить()); 
		
КонецПроцедуры

Процедура СформироватьТаблицаРеестрВвезенных(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВременнаяТаблицаШапка.Период КАК Период,
	|	ВременнаяТаблицаШапка.Организация КАК Организация,
	|	ВременнаяТаблицаТовары.ДокументПоступления.Контрагент КАК Контрагент,
	|	ВременнаяТаблицаШапка.НомерГТД КАК Номер,
	|	СУММА(ВременнаяТаблицаТовары.БазаНДС) КАК СуммаБезНДС,
	|	СУММА(ВременнаяТаблицаТовары.СуммаНДС) КАК СуммаНДС
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО (ИСТИНА)
	|ГДЕ
	|	(ВременнаяТаблицаТовары.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Зачет)
	|			ИЛИ ВременнаяТаблицаТовары.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаТовары.ДокументПоступления.Контрагент,
	|	ВременнаяТаблицаШапка.НомерГТД";
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеестрВвезенных", РезультатЗапроса.Выгрузить()); 
		                                     
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	ВалютаРегламентированногоУчета = СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета;
	УПП = СтруктураДополнительныеСвойства.УчетнаяПолитика;	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц 	= СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГТДПоИмпорту.Ссылка,
	|	ГТДПоИмпорту.Дата КАК Период,
	|	ГТДПоИмпорту.Организация,
	|	ГТДПоИмпорту.Склад,
	|	ГТДПоИмпорту.Контрагент,
	|	ГТДПоИмпорту.ДоговорКонтрагента,
	|	ГТДПоИмпорту.НомерГТД,
	|	&УказыватьПризнакЗачетаНДСПриПоступлении,
	|	ГТДПоИмпорту.СчетРасчетовСКонтрагентом,
	|	ГТДПоИмпорту.БазаНДС,
	|	ГТДПоИмпорту.СуммаСопровождения,
	|	ГТДПоИмпорту.СуммаДопРасходы,
	|	ГТДПоИмпорту.СуммаДоставки,
	|	ГТДПоИмпорту.СуммаАкциза,
	|	ГТДПоИмпорту.СуммаТаможенногоСбора,
	|	ГТДПоИмпорту.СуммаПошлины,
	|	ГТДПоИмпорту.СуммаНДС,
	|	&ВалютаДокумента,
	|	ГТДПоИмпорту.СтавкаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаШапка
	|ИЗ
	|	Документ.ГТДПоИмпорту КАК ГТДПоИмпорту
	|ГДЕ
	|	ГТДПоИмпорту.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГТДПоИмпортуТовары.Ссылка,
	|	ГТДПоИмпортуТовары.Номенклатура,
	|	ГТДПоИмпортуТовары.Количество,
	|	ГТДПоИмпортуТовары.СчетУчета,
	|	ГТДПоИмпортуТовары.СуммаНДС,
	|	ГТДПоИмпортуТовары.БазаНДС,
	|	ГТДПоИмпортуТовары.СуммаАкциза,
	|	ГТДПоИмпортуТовары.СуммаДопРасходы,
	|	ГТДПоИмпортуТовары.СуммаДоставки,
	|	ГТДПоИмпортуТовары.СуммаПошлины,
	|	ГТДПоИмпортуТовары.СуммаСопровождения,
	|	ГТДПоИмпортуТовары.СуммаТаможенногоСбора,
	|	ГТДПоИмпортуТовары.ЗачетНДС,
	|	ГТДПоИмпортуТовары.ДокументПоступления
	|ПОМЕСТИТЬ ВременнаяТаблицаТовары
	|ИЗ
	|	Документ.ГТДПоИмпорту.Товары КАК ГТДПоИмпортуТовары
	|ГДЕ
	|	ГТДПоИмпортуТовары.Ссылка = &ДокументСсылка";	
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаРегламентированногоУчета);
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДСПриПоступлении", УПП.УказыватьПризнакЗачетаНДСПриПоступлении);
	Запрос.Выполнить();    		
		
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);	
	СформироватьТаблицаНДСГТДИмпорт(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаНДСНаИмпорт(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаРеестрВвезенных(ДокументСсылка, СтруктураДополнительныеСвойства);

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

Функция ПечатьГТДПоИмпорту(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ 
	|	ГТДПоИмпорту.Ссылка,
	|	ГТДПоИмпорту.Дата,
	|	ГТДПоИмпорту.Номер,
	|	ГТДПоИмпорту.Организация.НаименованиеПолное КАК Покупатель,
	|	ГТДПоИмпорту.Контрагент.НаименованиеПолное КАК Таможня,
	|	ГТДПоИмпорту.СтавкаТаможенногоСбора КАК ТамСбор,
	|	ГТДПоИмпорту.СтавкаПошлины КАК Пошлина,
	|	ГТДПоИмпорту.СтавкаНДС,
	|	ГТДПоИмпорту.НомерГТД КАК ГТД,
	|	ГТДПоИмпорту.Товары. (
	|		Номенклатура КАК Товар,
	|		Количество,
	|		Цена,
	|		ФактурнаяСтоимость,
	|		СуммаДоставки КАК Доставка,
	|		СуммаДопРасходы КАК ДопРасходы,
	|		ТаможеннаяСтоимость КАК ТаможСтоимость,
	|		СуммаПошлины КАК Пошлина,
	|		СуммаТаможенногоСбора КАК ТаможСбор,
	|		СуммаАкциза КАК Акциз,
	|		СуммаСопровождения КАК Сопровождение,
	|		СуммаНДС
	|	),
	|	СтавкиНДССрезПоследних.Ставка КАК НДС
	|ИЗ
	|	Документ.ГТДПоИмпорту КАК ГТДПоИмпорту
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНДС.СрезПоследних КАК СтавкиНДССрезПоследних
	|	ПО ГТДПоИмпорту.СтавкаНДС = СтавкиНДССрезПоследних.СтавкаНДС
	|ГДЕ
	|	ГТДПоИмпорту.Ссылка В(&МассивОбъектов)";
	  
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	
	
	
	Если ИмяМакета = "ГТДПоИмпорту" Тогда
		
		ТабличныйДокумент.КлючПараметровПечати 	= "ГТДПоИмпорту_ГТДПоИмпорту";

		Результат = Запрос.Выполнить();
		Шапка = Результат.Выбрать();
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ГТДПоИмпорту.ГТДПоИмпорту");
		ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
		ОбластьШапкаТаблицы 	= Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьНалогиИСуммы 	= Макет.ПолучитьОбласть("НалогиИСуммы");
		ОбластьСтрока 			= Макет.ПолучитьОбласть("Строка");
		ОбластьИтого 			= Макет.ПолучитьОбласть("Итого");
		
		ТабличныйДокумент.Очистить();
			 
		Пока Шапка.Следующий() Цикл 
			ОбластьЗаголовок.Параметры.Заполнить(Шапка);
			ОбластьШапка.Параметры.Заполнить(Шапка);
			
			ФактурСтоимИтого	= Шапка.Товары.Выгрузить().Итог("ФактурнаяСтоимость");
			ДоставкаИтого 		= Шапка.Товары.Выгрузить().Итог("Доставка");
			ТамСтоимИтого		= Шапка.Товары.Выгрузить().Итог("ТаможСтоимость");
			ПошлинаИтого		= Шапка.Товары.Выгрузить().Итог("Пошлина");
			ТамСборИтого		= Шапка.Товары.Выгрузить().Итог("ТаможСбор");
			АкцизИтого 			= Шапка.Товары.Выгрузить().Итог("Акциз");
			СопровИтого			= Шапка.Товары.Выгрузить().Итог("Сопровождение");
			НДСИтого			= Шапка.Товары.Выгрузить().Итог("СуммаНДС");
			СтоимИтого			= Шапка.Товары.Выгрузить().Итог("ФактурнаяСтоимость")
								  + Шапка.Товары.Выгрузить().Итог("Доставка")
								  + Шапка.Товары.Выгрузить().Итог("Пошлина")
								  + Шапка.Товары.Выгрузить().Итог("ТаможСбор")
								  + Шапка.Товары.Выгрузить().Итог("Акциз")
								  + Шапка.Товары.Выгрузить().Итог("Сопровождение");
								  
			СтруктураИтоги = Новый Структура();
	  		СтруктураИтоги.Вставить("ФактурСтоимИтого", ФактурСтоимИтого);
			СтруктураИтоги.Вставить("ДоставкаИтого", ДоставкаИтого);
			СтруктураИтоги.Вставить("ТамСтоимИтого", ТамСтоимИтого);
			СтруктураИтоги.Вставить("ПошлинаИтого", ПошлинаИтого);
			СтруктураИтоги.Вставить("ТамСборИтого", ТамСборИтого);
			СтруктураИтоги.Вставить("АкцизИтого", АкцизИтого);
			СтруктураИтоги.Вставить("СопровИтого", СопровИтого);
			СтруктураИтоги.Вставить("НДСИтого", НДСИтого);
			СтруктураИтоги.Вставить("СтоимИтого", СтоимИтого);					  
								  
			ОбластьНалогиИСуммы.Параметры.Заполнить(Шапка);
			ОбластьНалогиИСуммы.Параметры.Заполнить(СтруктураИтоги);
			
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);
			ТабличныйДокумент.Вывести(ОбластьШапка);
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			ТабличныйДокумент.Вывести(ОбластьНалогиИСуммы);
			
				ВыборкаСтрокТовары = Шапка.Товары.Выбрать();              
				НомерСтроки = 1;
				Пока ВыборкаСтрокТовары.Следующий() Цикл  
					
					ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
					ОбластьСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
					
					Стоимость	 = ВыборкаСтрокТовары.ФактурнаяСтоимость
									+ ВыборкаСтрокТовары.Доставка
									+ ВыборкаСтрокТовары.Пошлина
									+ ВыборкаСтрокТовары.ТаможСбор
									+ ВыборкаСтрокТовары.Акциз
									+ ВыборкаСтрокТовары.Сопровождение;
					
					ИтоговаяЦена = Стоимость / ВыборкаСтрокТовары.Количество;
					
					ОбластьСтрока.Параметры.Стоимость 	 = Стоимость;
					ОбластьСтрока.Параметры.ИтоговаяЦена = ИтоговаяЦена;
								
					ТабличныйДокумент.Вывести(ОбластьСтрока);
					
					НомерСтроки = НомерСтроки + 1;
					
				КонецЦикла;
				
			ОбластьИтого.Параметры.Заполнить(СтруктураИтоги);
			
			ТабличныйДокумент.Вывести(ОбластьИтого);

		КонецЦикла;
		
	Иначе
		
		ТабличныйДокумент.КлючПараметровПечати 	= "ГТДПоИмпорту_ГТДПоИмпортуПолная";	

		Результат = Запрос.Выполнить();
		Шапка = Результат.Выбрать();
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ГТДПоИмпорту.ГТДПоИмпортуПолная");
		ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
		ОбластьШапкаТаблицы 	= Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьНалогиИСуммы 	= Макет.ПолучитьОбласть("НалогиИСуммы");
		ОбластьСтрока 			= Макет.ПолучитьОбласть("Строка");
		ОбластьИтого 			= Макет.ПолучитьОбласть("Итого");
		
		ТабличныйДокумент.Очистить();
			 
		Пока Шапка.Следующий() Цикл 
			ОбластьЗаголовок.Параметры.Заполнить(Шапка);
			ОбластьШапка.Параметры.Заполнить(Шапка);
			
			ФактурСтоимИтого	= Шапка.Товары.Выгрузить().Итог("ФактурнаяСтоимость");
			ДоставкаИтого 		= Шапка.Товары.Выгрузить().Итог("Доставка");
			ДопРасходыИтого 	= Шапка.Товары.Выгрузить().Итог("ДопРасходы");
			ТамСтоимИтого		= Шапка.Товары.Выгрузить().Итог("ТаможСтоимость");
			ПошлинаИтого		= Шапка.Товары.Выгрузить().Итог("Пошлина");
			ТамСборИтого		= Шапка.Товары.Выгрузить().Итог("ТаможСбор");
			АкцизИтого 			= Шапка.Товары.Выгрузить().Итог("Акциз");
			СопровИтого			= Шапка.Товары.Выгрузить().Итог("Сопровождение");
			НДСИтого			= Шапка.Товары.Выгрузить().Итог("СуммаНДС");
			СтоимИтого			= Шапка.Товары.Выгрузить().Итог("ФактурнаяСтоимость")
								  + Шапка.Товары.Выгрузить().Итог("Доставка")
								  + Шапка.Товары.Выгрузить().Итог("Пошлина")
								  + Шапка.Товары.Выгрузить().Итог("ТаможСбор")
								  + Шапка.Товары.Выгрузить().Итог("Акциз")
								  + Шапка.Товары.Выгрузить().Итог("Сопровождение");
			СтоимИтогоБезДост	= Шапка.Товары.Выгрузить().Итог("ФактурнаяСтоимость")
								  + Шапка.Товары.Выгрузить().Итог("Пошлина")
								  + Шапка.Товары.Выгрузить().Итог("ТаможСбор")
								  + Шапка.Товары.Выгрузить().Итог("Акциз")
								  + Шапка.Товары.Выгрузить().Итог("Сопровождение");
								  
			СтруктураИтоги = Новый Структура();
	  		СтруктураИтоги.Вставить("ФактурСтоимИтого", ФактурСтоимИтого);
			СтруктураИтоги.Вставить("ДоставкаИтого", ДоставкаИтого);
			СтруктураИтоги.Вставить("ДопРасходыИтого", ДопРасходыИтого);
			СтруктураИтоги.Вставить("ТамСтоимИтого", ТамСтоимИтого);
			СтруктураИтоги.Вставить("ПошлинаИтого", ПошлинаИтого);
			СтруктураИтоги.Вставить("ТамСборИтого", ТамСборИтого);
			СтруктураИтоги.Вставить("АкцизИтого", АкцизИтого);
			СтруктураИтоги.Вставить("СопровИтого", СопровИтого);
			СтруктураИтоги.Вставить("НДСИтого", НДСИтого);
			СтруктураИтоги.Вставить("СтоимИтого", СтоимИтого);	
			СтруктураИтоги.Вставить("СтоимИтогоБезДост", СтоимИтогоБезДост);
								  
			ОбластьНалогиИСуммы.Параметры.Заполнить(Шапка);
			ОбластьНалогиИСуммы.Параметры.Заполнить(СтруктураИтоги);
			
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);
			ТабличныйДокумент.Вывести(ОбластьШапка);
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			ТабличныйДокумент.Вывести(ОбластьНалогиИСуммы);
			
				ВыборкаСтрокТовары = Шапка.Товары.Выбрать();              
				НомерСтроки = 1;
				Пока ВыборкаСтрокТовары.Следующий() Цикл  
					
					ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
					ОбластьСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
					
					Стоимость	     = ВыборкаСтрокТовары.ФактурнаяСтоимость
									  + ВыборкаСтрокТовары.Доставка
									  + ВыборкаСтрокТовары.Пошлина
									  + ВыборкаСтрокТовары.ТаможСбор
									  + ВыборкаСтрокТовары.Акциз
									  + ВыборкаСтрокТовары.Сопровождение;
									
					СтоимостьБезДост = ВыборкаСтрокТовары.ФактурнаяСтоимость
									  + ВыборкаСтрокТовары.Пошлина
									  + ВыборкаСтрокТовары.ТаможСбор
									  + ВыборкаСтрокТовары.Акциз
									  + ВыборкаСтрокТовары.Сопровождение;
					
					ИтоговаяЦена = Стоимость / ВыборкаСтрокТовары.Количество;
					
					ОбластьСтрока.Параметры.Стоимость 	 	  = Стоимость;
					ОбластьСтрока.Параметры.СтоимостьБезДост  = СтоимостьБезДост;
					ОбластьСтрока.Параметры.ИтоговаяЦена	  = ИтоговаяЦена;
								
					ТабличныйДокумент.Вывести(ОбластьСтрока);
					
					НомерСтроки = НомерСтроки + 1;
					
				КонецЦикла;
				
			ОбластьИтого.Параметры.Заполнить(СтруктураИтоги);
			
			ТабличныйДокумент.Вывести(ОбластьИтого);

		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект;
//                                            представление – имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ГТДПоИмпорту") Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
				"ГТДПоИмпорту", НСтр("ru = 'ГТД_По_Импорту'"), ПечатьГТДПоИмпорту(МассивОбъектов, ОбъектыПечати,"ГТДПоИмпорту"),,
				"Документ.ГТДПоИмпорту.ГТДПоИмпорту");
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ГТДПоИмпортуПолная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ГТДПоИмпортуПолная", НСтр("ru = 'ГТД_По_Импорту_Полная'"), ПечатьГТДПоИмпорту(МассивОбъектов, ОбъектыПечати, "ГТДПоИмпортуПолная"),,
			"Документ.ГТДПоИмпорту.ГТДПоИмпортуПолная");
	КонецЕсли;
		
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ГТДПоИмпорту";
	КомандаПечати.Представление = НСтр("ru = 'ГТД_По_Импорту'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ГТДПоИмпортуПолная";
	КомандаПечати.Представление = НСтр("ru = 'ГТД_По_Импорту_Полная'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 2;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
