﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	СуммаДокумента = МБП.Итог("Сумма");
	СуммаПоУчету = МБП.Итог("УчетнаяСумма");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть МБП.
//
Процедура ЗаполнитьМБП() Экспорт 	
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура,
		|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Номенклатура).Наименование КАК НаименованиеНоменклатура,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК УчетнаяСумма,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК УчетноеКоличество,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК Количество,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйОстатки.КоличествоОстаток <> 0
		|			ТОГДА ХозрасчетныйОстатки.СуммаОстаток / ХозрасчетныйОстатки.КоличествоОстаток
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Цена
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В (&СчетаУчетаМБП),
		|			&ВидыСубконто,
		|			Организация = &Организация
		|				И Субконто2 ССЫЛКА Справочник.ФизическиеЛица
		|				И Субконто2 = &ФизЛицо) КАК ХозрасчетныйОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеНоменклатура";
	Если НЕ ЗначениеЗаполнено(ФизЛицо) Тогда
	    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Субконто2 = &ФизЛицо", "Истина");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	СчетаУчетаМБП = БухгалтерскийУчетСервер.СчетаУчетаМБП();
	Запрос.УстановитьПараметр("СчетаУчетаМБП", СчетаУчетаМБП);	
	
	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Местонахождение);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	
	МБП.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли