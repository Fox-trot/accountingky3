﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Владелец = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	ВалютаДенежныхСредств = Константы.ВалютаРегламентированногоУчета.Получить();
КонецПроцедуры

#КонецОбласти

#КонецЕсли