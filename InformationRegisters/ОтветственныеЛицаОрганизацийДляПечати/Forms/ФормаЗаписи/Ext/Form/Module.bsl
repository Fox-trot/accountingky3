﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Запись.ОбъектОтчет) Тогда
		ТекстСообщения = НСтр("ru = 'Для указания ответственных лиц необходимо открыть стандартную обработку.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		Возврат;
	КонецЕсли;	

	Если Параметры.Ключ.Пустой() Тогда
		Запись.Период = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		
		ОтветственныеЛицаОрганизаций = РегистрыСведений.ОтветственныеЛицаОрганизацийДляПечати.СоздатьМенеджерЗаписи();
		ОтветственныеЛицаОрганизаций.Период				= Запись.ИсходныйКлючЗаписи.Период;
		ОтветственныеЛицаОрганизаций.ОбъектОтчет		= Запись.ИсходныйКлючЗаписи.ОбъектОтчет;
		ОтветственныеЛицаОрганизаций.ОтветственноеЛицо	= Запись.ИсходныйКлючЗаписи.ОтветственноеЛицо;
		ОтветственныеЛицаОрганизаций.Прочитать();
		
		СтруктураСтаройЗаписи	= Новый Структура("Период, ОбъектОтчет, ОтветственноеЛицо");
		ЗаполнитьЗначенияСвойств(СтруктураСтаройЗаписи, ОтветственныеЛицаОрганизаций);
		ПараметрыЗаписи.Вставить("СтруктураСтаройЗаписи", СтруктураСтаройЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ПараметрыЗаписи.Свойство("СтруктураСтаройЗаписи") Тогда
		
		// Если была изменена дата и хотя бы одно из полей, тогда сохраним прежнюю запись	
		Если НЕ ТекущийОбъект.Период = ПараметрыЗаписи.СтруктураСтаройЗаписи.Период Тогда
			ОтветственныеЛицаОрганизаций	= РегистрыСведений.ОтветственныеЛицаОрганизацийДляПечати.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(ОтветственныеЛицаОрганизаций, ТекущийОбъект);
			ЗаполнитьЗначенияСвойств(ОтветственныеЛицаОрганизаций, ПараметрыЗаписи.СтруктураСтаройЗаписи);
			ОтветственныеЛицаОрганизаций.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсторияИзменений(Команда)
	Отбор	= Новый Структура("ОбъектОтчет, ОтветственноеЛицо");
	ЗаполнитьЗначенияСвойств(Отбор, Запись);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизацийДляПечати.ФормаСписка", Новый Структура("Отбор", Отбор));
КонецПроцедуры

#КонецОбласти



