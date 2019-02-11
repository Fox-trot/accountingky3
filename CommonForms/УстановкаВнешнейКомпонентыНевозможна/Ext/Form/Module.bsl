﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(Параметры.ТекстПояснения) Тогда
		Элементы.ДекорацияПояснение.Заголовок = СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
				           |
				           |Не предусмотрена работа внешней компоненты 
				           |в клиентском приложении <b>%2</b>.
				           |Используйте <a href = about:blank>поддерживаемое клиентское приложение</a> или обратитесь к разработчику внешней компоненты.'"),
				Параметры.ТекстПояснения,
				ПредставлениеТекущегоКлиента()));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоддерживаемыеКлиенты", Параметры.ПоддерживаемыеКлиенты);
	
	ОткрытьФорму("ОбщаяФорма.ПоддерживаемыеКлиентскиеПриложения", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПредставлениеТекущегоКлиента()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
#Если ВебКлиент Тогда
	Строка = СистемнаяИнформация.ИнформацияПрограммыПросмотра;
	
	Если СтрНайти(Строка, "Chrome/") > 0 Тогда
		Браузер = "Chrome";
	ИначеЕсли СтрНайти(Строка, "MSIE") > 0 Тогда
		Браузер = "Internet Explorer";
	ИначеЕсли СтрНайти(Строка, "Safari/") > 0 Тогда
		Браузер = "Safari";
	ИначеЕсли СтрНайти(Строка, "Firefox/") > 0 Тогда
		Браузер = "Firefox";
	КонецЕсли;
	
	Представление = НСтр("ru = 'веб-клиент'") + " " + Браузер + " " + НСтр("ru = 'в'");
#ИначеЕсли МобильноеПриложениеКлиент  Тогда
	Представление = НСтр("ru = 'мобильное приложение'");
#ИначеЕсли МобильныйКлиент Тогда
	Представление = НСтр("ru = 'мобильный клиент'");
#ИначеЕсли ТонкийКлиент Тогда
	Представление = НСтр("ru = 'тонкий клиент'");
#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
	Представление = НСтр("ru = 'толстый клиент (обычное приложение)'");
#ИначеЕсли ТолстыйКлиентУправляемоеПриложение  Тогда
	Представление = НСтр("ru = 'толстый клиент'");
#КонецЕсли
	
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда 
		Представление = Представление + " " + "Windows x86";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда 
		Представление = Представление + " " + "Windows x86-64";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда 
		Представление = Представление + " " + "Linux x86";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда 
		Представление = Представление + " " + "Linux x86-64";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86 Тогда 
		Представление = Представление + " " + "MacOS x86";
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64 Тогда 
		Представление = Представление + " " + "MacOS x86-64";
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти