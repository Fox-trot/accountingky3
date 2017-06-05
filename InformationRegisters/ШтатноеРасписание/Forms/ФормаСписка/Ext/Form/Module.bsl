﻿
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Отбор.Свойство("Организация") Тогда
		Организация = Параметры.Отбор.Организация;
	Иначе
		Организация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.УстановитьЭлементОтбораСписка(Список,"Организация",Организация);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработка события ПриИзменении реквизита Организация
//
Процедура ОрганизацияПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Подразделения, "Организация", Организация, ЗначениеЗаполнено(Организация));
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));
КонецПроцедуры

&НаКлиенте
// Процедура - обработка события ПриАктивизацииСтроки таблицы Подразделения
//
Процедура ПодразделенияПриАктивизацииСтроки(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Подразделение", Элемент.ТекущиеДанные.Ссылка, Истина);
КонецПроцедуры

#КонецОбласти





