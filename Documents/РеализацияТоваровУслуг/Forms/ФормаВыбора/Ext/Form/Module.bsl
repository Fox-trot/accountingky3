﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДокументВозвратаТоваров") Тогда
		ДокументВозвратаТоваров = Параметры.ДокументВозвратаТоваров;
	Иначе
		ДокументВозвратаТоваров = Ложь;
	КонецЕсли;
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Список.Параметры.УстановитьЗначениеПараметра("ДокументВозвратаТоваров", ДокументВозвратаТоваров);
КонецПроцедуры

#КонецОбласти	