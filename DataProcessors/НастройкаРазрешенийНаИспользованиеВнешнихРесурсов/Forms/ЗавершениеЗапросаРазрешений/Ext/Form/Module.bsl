﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем РазрешитьЗакрытие;

&НаКлиенте
Перем ОжиданиеЗавершено;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Длительность = Параметры.Длительность;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазрешитьЗакрытие = Ложь;
	
	Если Длительность > 0 Тогда
		ОжиданиеЗавершено = Ложь;
		ПодключитьОбработчикОжидания("ПослеОжиданияПримененияНастроекВКластере", Длительность, Истина);
	Иначе
		ОжиданиеЗавершено = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не РазрешитьЗакрытие Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОжиданияПримененияНастроекВКластере()
	
	РазрешитьЗакрытие = Истина;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти