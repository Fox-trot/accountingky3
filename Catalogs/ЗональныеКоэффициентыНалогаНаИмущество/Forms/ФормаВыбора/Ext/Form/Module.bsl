﻿
#Область ОбработчикиСобытийЭлементовТаблицыФормы

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
		ОткрытьФорму("Справочник.ЗональныеКоэффициентыНалогаНаИмущество.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
&НаКлиенте
Процедура ПодобратьИзКлассификатора()
	СоответствиеПолей = Новый Соответствие;
	СоответствиеПолей.Вставить("Коэффициент", "Коэффициент");
	СоответствиеПолей.Вставить("Описание", "Описание");
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуПодбораИзКлассификатора(
		"ЗональныеКоэффициентыНалогаНаИмущество", "Справочник.ЗональныеКоэффициентыНалогаНаИмущество.Классификатор", НСтр("ru = 'Зональные коэффициенты для расчета налога на имущество'"), ЭтаФорма, СоответствиеПолей);
КонецПроцедуры

#КонецОбласти
