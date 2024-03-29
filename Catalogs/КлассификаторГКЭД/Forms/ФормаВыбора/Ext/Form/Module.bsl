﻿
#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Текст = НСтр("ru = 'Есть возможность подобрать из сервиса.
		|Подобрать?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("Наименование", ТекущиеДанные.Наименование);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьИзСервиса", ЭтотОбъект, ДополнительныеПараметры);
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
Процедура ВопросПодобратьИзСервиса(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора();
	Иначе
		ОткрытьФорму("Справочник.КлассификаторГКЭД.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
&НаКлиенте
Процедура ПодобратьИзКлассификатора()
	ОбщегоНазначенияБПКлиент.ОткрытьФормуПодбораИзКлассификатора(
		"КлассификаторГКЭД", "ClassifierGKEDWsGetService", НСтр("ru = 'Классификатор ГКЭД'"), ЭтаФорма);
КонецПроцедуры

#КонецОбласти
