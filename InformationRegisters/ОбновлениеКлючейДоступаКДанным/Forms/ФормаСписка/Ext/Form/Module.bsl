﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеДоступаНаУровнеЗаписей(Команда)
	
	ОткрытьФорму("РегистрСведений.ОбновлениеКлючейДоступаКДанным.Форма.ОбновлениеДоступаНаУровнеЗаписей");
	
КонецПроцедуры

#КонецОбласти
