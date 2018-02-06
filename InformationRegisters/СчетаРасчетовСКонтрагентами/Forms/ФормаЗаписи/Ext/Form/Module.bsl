﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Запись.Организация) Тогда 
		Запись.Организация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	КонецЕсли;
	
	// Это не новая запись
	Если ЗначениеЗаполнено(Запись.СчетРасчетовПоставщика) Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	Элементы.ФормаВключитьВозможностьРедактирования.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти
