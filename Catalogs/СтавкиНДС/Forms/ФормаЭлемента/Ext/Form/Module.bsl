﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ТолькоПросмотр = Истина;
	
	ЗаполнитьДанныеОСтавке();
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененаСтавкаНДС" Тогда 
		ЗаполнитьДанныеОСтавке();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Заполнить данные о ставке
//
&НаСервере
Процедура ЗаполнитьДанныеОСтавке()
	ПериодСтавки = ТекущаяДатаСеанса();
	Ставка = УчетНДСВызовСервера.ПолучитьСтавкуНДС(ПериодСтавки, Объект.Ссылка);
КонецПроцедуры // ЗаполнитьДанныеОСтавке()

#КонецОбласти
