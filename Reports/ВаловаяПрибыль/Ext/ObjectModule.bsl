﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Проверки = Новый Структура("КорректностьПериода", Истина);
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, Проверки);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Отключаем стандартную обработку, т.к. формировать отчет будем "вручную".
	СтандартнаяОбработка = Ложь;
	БухгалтерскиеОтчетыВызовСервера.ОбработкаСобытияПриКомпоновкеРезультата(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ПередЗагрузкойНастроекВКомпоновщик(ЭтотОбъект, Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
	СхемаКомпоновкиДанных = ПолучитьМакет("СхемаКомпоновкиДанных");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли