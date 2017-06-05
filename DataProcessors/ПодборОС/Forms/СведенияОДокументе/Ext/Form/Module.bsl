﻿#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	ЗаполнитьНадписьСостоянияОС(Объект.СостоянияОС);
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура заполняет декорациию с перечнем состояний ОС
//
Процедура ЗаполнитьНадписьСостоянияОС(СостоянияОС)
	
	Для каждого ЭлементСписка Из СостоянияОС Цикл
		Элементы.ДекорацияСостоянияОССодержание.Заголовок = Элементы.ДекорацияСостоянияОССодержание.Заголовок 
			+ ?(ПустаяСтрока(Элементы.ДекорацияСостоянияОССодержание.Заголовок), "", ", ") + ЭлементСписка.Значение;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьНадписьСостоянияОС()

#КонецОбласти
