﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;

	ЗаполнитьДанныеОСтавке();
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененаСтавкаНСП" Тогда 
		ЗаполнитьДанныеОСтавке();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Заполнить данные о ставке
//
&НаСервере
Процедура ЗаполнитьДанныеОСтавке()
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	ПериодСтавки = ТекущаяДатаСеанса();

	Ставка = УчетНДСВызовСервера.ПолучитьСтавкуНСП(ПериодСтавки, ОсновнаяОрганизация, Объект.Ссылка);
КонецПроцедуры // ЗаполнитьДанныеОСтавке()

#КонецОбласти
