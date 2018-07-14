﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ТекстПояснения) Тогда
		Элементы.ДекорацияПояснение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Отсутствует компонента для используемого клиентского приложения.
			           |Обратитесь к администратору.'"),
			Параметры.ТекстПояснения);
	КонецЕсли;
	
	// Заполнение реквизитов поддерживаемых клиентов.
	Если ТипЗнч(Параметры.ПоддерживаемыеКлиенты) = Тип("Структура") Тогда 
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПоддерживаемыеКлиенты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Элементы.ДекорацияИспользуется.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Используется: 
		           |Операционная система:%1
		           |Платформа: %2
		           |UserAgent: %3'"),
		СистемнаяИнформация.ВерсияОС,
		СистемнаяИнформация.ТипПлатформы,
		?(ПустаяСтрока(СистемнаяИнформация.ИнформацияПрограммыПросмотра), 
			"<None>",
			СистемнаяИнформация.ИнформацияПрограммыПросмотра));
	
КонецПроцедуры

#КонецОбласти