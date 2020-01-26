﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть Товары.
//
Процедура ЗаполнитьТовары() Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура,
		|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Номенклатура).Наименование КАК НаименованиеНоменклатура,
		|	ХозрасчетныйОстатки.Субконто2 КАК Склад,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК УчетнаяСумма,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК УчетноеКоличество,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК Количество,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйОстатки.КоличествоОстаток <> 0
		|			ТОГДА ХозрасчетныйОстатки.СуммаОстаток / ХозрасчетныйОстатки.КоличествоОстаток
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Цена,
		|	ХозрасчетныйОстатки.Счет КАК СчетУчета,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В (&СчетаУчетаТоваров),
		|			&ВидыСубконто,
		|			Организация = &Организация
		|				И Субконто2 = &Склад) КАК ХозрасчетныйОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеНоменклатура";
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	СчетаУчетаТоваров = БухгалтерскийУчетСервер.СчетаУчетаТоваров();
	Запрос.УстановитьПараметр("СчетаУчетаТоваров", СчетаУчетаТоваров);	
	
	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли