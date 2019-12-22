﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ТекущаяДата", ТекущаяДата);

КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененОтраслевойКоэффициент" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	Перем ТекущаяДата;
	
	Если Не Настройки.ДополнительныеСвойства.Свойство("ТекущаяДата", ТекущаяДата) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КоэффициентыНалогаНаИмущество.Классификация КАК Классификация,
		|	КоэффициентыНалогаНаИмущество.Коэффициент КАК Коэффициент
		|ИЗ
		|	РегистрСведений.КоэффициентыНалогаНаИмущество.СрезПоследних(&КонецПериода, Классификация В (&Классификация)) КАК КоэффициентыНалогаНаИмущество";
	Запрос.УстановитьПараметр("Классификация", Строки.ПолучитьКлючи());
	Запрос.УстановитьПараметр("КонецПериода", ТекущаяДата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаСписка = Строки[Выборка.Классификация];
		СтрокаСписка.Данные["Коэффициент"] = Выборка.Коэффициент;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Текст = НСтр("ru = 'Есть возможность подобрать коэффициенты из классификатора.
		|Подобрать?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("Наименование", ТекущиеДанные.Наименование);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьЕдиницуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПодборИзКлассификатора(Команда)
	ПодобратьИзКлассификатора();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ВопросПодобратьЕдиницуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора();
	Иначе
		ОткрытьФорму("Справочник.ОтраслевыеКоэффициентыНалогНаИмущество.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
&НаКлиенте
Процедура ПодобратьИзКлассификатора()
	СоответствиеПолей = Новый Соответствие;
	СоответствиеПолей.Вставить("Коэффициент", "Коэффициент");
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуПодбораИзКлассификатора(
		"ОтраслевыеКоэффициентыНалогНаИмущество", 
		"Справочник.ОтраслевыеКоэффициентыНалогНаИмущество.Классификатор", 
		НСтр("ru = 'Отраслевые коэффициенты для расчета налога на имущество'"), 
		ЭтаФорма, 
		СоответствиеПолей,
		,
		"Справочники.ОтраслевыеКоэффициентыНалогНаИмущество.ОбработатьПодобранныйЭлемент");
КонецПроцедуры

#КонецОбласти
