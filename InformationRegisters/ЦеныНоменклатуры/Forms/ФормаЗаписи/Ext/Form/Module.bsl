﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаписьБылаЗаписана = Ложь;
	
	Если Параметры.ЗначенияЗаполнения.Количество() > 0 
		И Параметры.ЗначенияЗаполнения.Свойство("Период") 
		И Параметры.ЗначенияЗаполнения.Свойство("Организация") 
		И Параметры.ЗначенияЗаполнения.Свойство("ТипЦен") Тогда
		
		Запись.Период 		= Параметры.ЗначенияЗаполнения.Период;
		Запись.Организация 	= Параметры.ЗначенияЗаполнения.Организация;
		Запись.ТипЦен		= Параметры.ЗначенияЗаполнения.ТипЦен;
		Запись.Номенклатура = Параметры.ЗначенияЗаполнения.Номенклатура;
		
		ТипЦенПриИзмененииНаСервере();
		
	ИначеЕсли Параметры.ЗначенияЗаполнения.Количество() > 0 Тогда
		Запись.Номенклатура = Параметры.ЗначенияЗаполнения.Номенклатура;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	ТипЦенПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТипЦенПриИзмененииНаСервере()

	Запись.Валюта = Запись.ТипЦен.ВалютаЦены;	

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗаписьБылаЗаписана Тогда
		Оповестить("ИзмененаЦена", ЗаписьБылаЗаписана);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаписьБылаЗаписана = Истина;
	
КонецПроцедуры
