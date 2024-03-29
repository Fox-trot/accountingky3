﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
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
Процедура ПриОткрытии(Отказ)
	
	УстановитьФорматЦены();	
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ТипЦен.
//
&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	ТипЦенПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТипЦенПриИзмененииНаСервере()

	Запись.Валюта = Запись.ТипЦен.ВалютаЦены;	

КонецПроцедуры

&НаКлиенте
Процедура ТочностьЦеныПриИзменении(Элемент)
	
	УстановитьФорматЦены();	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает формат и формат редактирования элемента "Цена"
//
&НаКлиенте
Процедура УстановитьФорматЦены()

	Если Запись.ТочностьЦены = 4 Тогда
		
		Элементы.Цена.ФорматРедактирования = "ЧЦ=15; ЧДЦ=4";
		Элементы.Цена.Формат = "ЧЦ=15; ЧДЦ=4";
		
	ИначеЕсли Запись.ТочностьЦены = 3 Тогда
		
		Элементы.Цена.ФорматРедактирования = "ЧЦ=15; ЧДЦ=3";
		Элементы.Цена.Формат = "ЧЦ=15; ЧДЦ=3";
		
	Иначе
		Элементы.Цена.ФорматРедактирования = "ЧЦ=15; ЧДЦ=2";
		Элементы.Цена.Формат = "ЧЦ=15; ЧДЦ=2";
	КонецЕсли;	

	ОбновитьИнтерфейс();
КонецПроцедуры

#КонецОбласти
