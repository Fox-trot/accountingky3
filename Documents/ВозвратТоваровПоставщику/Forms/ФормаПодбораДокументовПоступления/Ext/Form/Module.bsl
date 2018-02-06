﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("Контрагент", Параметры.Контрагент);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("ДатаОтбора", Параметры.ДатаОтбора);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДокументовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Оповестить("ПодборДокументовПоступления", Значение);
	Закрыть()
КонецПроцедуры

#КонецОбласти
