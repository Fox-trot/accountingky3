﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИспользуетсяНесколькоОрганизацийЭД = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБЭД");
	
	Если ИспользуетсяНесколькоОрганизацийЭД Тогда
		Элементы.ПустаяДекорация.Видимость = Ложь;
	ИначеЕсли Не ИспользуетсяНесколькоОрганизацийЭД И НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	ВидимостьПолейСумма(ЭтотОбъект, Объект.НаправлениеПлатежа);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура НаправлениеПлатежаПриИзменении(Элемент)
	
	ВидимостьПолейСумма(ЭтотОбъект, Объект.НаправлениеПлатежа);
	Если Объект.НаправлениеПлатежа = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий") Тогда
		Объект.Поступление = Макс(Объект.Поступление, Объект.Списание);
		Объект.Списание = 0;
	Иначе 
		Объект.Списание = Макс(Объект.Поступление, Объект.Списание);
		Объект.Поступление = 0;
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьПолейСумма(Форма, Направление)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"СуммаПоступления",
		"Видимость",
		Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"СуммаСписания",
		"Видимость",
		Не Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	
КонецПроцедуры

#КонецОбласти