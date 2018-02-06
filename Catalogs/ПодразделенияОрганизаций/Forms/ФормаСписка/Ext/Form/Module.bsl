﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОсновнаяОрганизация	= БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	
	Если ОтборОрганизация.Пустая() Тогда
		ОтборОрганизация = ОсновнаяОрганизация;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ЕстьОтборПоВладельцу = Истина;
		ОтборОрганизация     = Параметры.Отбор.Владелец;
		Элементы.СтраницыОтборОрганизация.ТекущаяСтраница = Элементы.ГруппаОтображениеОрганизация;
	Иначе
		ЕстьОтборПоВладельцу = Ложь;
		ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		Элементы.СтраницыОтборОрганизация.ТекущаяСтраница = Элементы.ГруппаОтборОрганизация;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
			"Владелец",
			ОтборОрганизация,
			,
			,
			ОтборОрганизацияИспользование);
	КонецЕсли;
	
	ИспользуетсяНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	Элементы.Организация.Видимость                   = ИспользуетсяНесколькоОрганизаций;
	Элементы.ОтборОрганизация.Видимость              = ИспользуетсяНесколькоОрганизаций;
	Элементы.ОтборОрганизацияИспользование.Видимость = ИспользуетсяНесколькоОрганизаций;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		"Владелец",
		ОтборОрганизация,
		,
		,
		ОтборОрганизацияИспользование);

КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОтборОрганизацияИспользование = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		"Владелец",
		ОтборОрганизация,
		,
		,
		ОтборОрганизацияИспользование);
	
КонецПроцедуры

#КонецОбласти