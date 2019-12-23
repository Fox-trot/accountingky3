﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборПоОрганизации()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		"Владелец",
		ОтборОрганизация,
		Неопределено,
		,
		ОтборОрганизацияИспользование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ОтборОрганизация = Параметры.Отбор.Владелец;
		Параметры.Отбор.Удалить("Владелец");
	КонецЕсли;
	
	Если Не Справочники.Организации.ИспользуетсяНесколькоОрганизаций() 
		И Не ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОтборОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		Элементы.ГруппаОтборОрганизация.Доступность = Ложь;
	КонецЕсли;
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборПоОрганизации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ОтборОрганизация.
//
&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	УстановитьОтборПоОрганизации();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ОтборОрганизацияИспользование.
//
&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	УстановитьОтборПоОрганизации();

КонецПроцедуры

#КонецОбласти