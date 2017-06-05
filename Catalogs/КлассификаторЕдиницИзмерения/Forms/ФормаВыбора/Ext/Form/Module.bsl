﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <Список>

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Текст = НСтр("ru = 'Есть возможность подобрать единицу измерения из классификатора.
		|Подобрать?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", Элемент.ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("Наименование", Элемент.ТекущиеДанные.Наименование);
		ЗначенияЗаполнения.Вставить("НаименованиеПолное", Элемент.ТекущиеДанные.НаименованиеПолное);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьЕдиницуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодобратьИзМакета(Команда)
	
	СтрокаПоиска = "";
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		СтрокаПоиска = ТекДанные.Код;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("СтрокаПоиска", СтрокаПоиска);
	ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаВыбораИзКлассификатора",
		СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВопросПодобратьЕдиницуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзМакета(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

