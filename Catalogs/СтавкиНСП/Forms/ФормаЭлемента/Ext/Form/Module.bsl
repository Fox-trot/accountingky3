﻿
#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура - Заполнить данные о ставке
//
&НаСервере
Процедура ЗаполнитьДанныеОСтавке()
	ДанныеОСтавкеПлательщикНДС = БухгалтерскийУчетСервер.ПолучитьСтавкуНСП(ТекущаяДата(), ПредопределенноеЗначение("Справочник.СтавкиНДС.Стандарт"), Объект.Ссылка);	
	СтавкаПлательщикНДС = ДанныеОСтавкеПлательщикНДС.Ставка;
	ПериодСтавкиПлательщикНДС = ДанныеОСтавкеПлательщикНДС.Период;
	
	ДанныеОСтавкеНеПлательщикНДС = БухгалтерскийУчетСервер.ПолучитьСтавкуНСП(ТекущаяДата(), ПредопределенноеЗначение("Справочник.СтавкиНДС.БезНДС"), Объект.Ссылка);	
	СтавкаНеПлательщикНДС = ДанныеОСтавкеНеПлательщикНДС.Ставка;
	ПериодСтавкиНеПлательщикНДС = ДанныеОСтавкеНеПлательщикНДС.Период;
КонецПроцедуры // ЗаполнитьДанныеОСтавке()

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - При создании на сервере
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьДанныеОСтавке();
КонецПроцедуры

// Процедура - Обработка оповещения
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененаСтавкаНДС" Тогда 
		ЗаполнитьДанныеОСтавке();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


