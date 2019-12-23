﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекстПояснения = Параметры.ТекстПояснения;
	
	Если ПустаяСтрока(ТекстПояснения) Тогда 
		ТекстПояснения = НСтр("ru = 'Установка внешней компоненты невозможна.'");
	КонецЕсли;
	
	Элементы.ДекорацияПояснение.Заголовок = СтроковыеФункцииКлиент.ФорматированнаяСтрока(НСтр("ru = '%1
			           |
			           |Не предусмотрена работа внешней компоненты 
			           |в клиентском приложении <b>%2</b>.
			           |Используйте <a href = about:blank>поддерживаемое клиентское приложение</a> или обратитесь к разработчику внешней компоненты.'"),
			ТекстПояснения,
			ПредставлениеТекущегоКлиента());
	
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
		Браузер = НСтр("ru = 'Chrome'");
	ИначеЕсли СтрНайти(Строка, "MSIE") > 0 Тогда
		Браузер = НСтр("ru = 'Internet Explorer'");
	ИначеЕсли СтрНайти(Строка, "Safari/") > 0 Тогда
		Браузер = НСтр("ru = 'Safari'");
	ИначеЕсли СтрНайти(Строка, "Firefox/") > 0 Тогда
		Браузер = НСтр("ru = 'Firefox'");
	КонецЕсли;
	
	Приложение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'веб-клиент %1'"), Браузер);
#ИначеЕсли МобильноеПриложениеКлиент Тогда
	Приложение = НСтр("ru = 'мобильное приложение'");
#ИначеЕсли МобильныйКлиент Тогда
	Приложение = НСтр("ru = 'мобильный клиент'");
#ИначеЕсли ТонкийКлиент Тогда
	Приложение = НСтр("ru = 'тонкий клиент'");
#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
	Приложение = НСтр("ru = 'толстый клиент (обычное приложение)'");
#ИначеЕсли ТолстыйКлиентУправляемоеПриложение Тогда
	Приложение = НСтр("ru = 'толстый клиент'");
#КонецЕсли
	
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда 
		Платформа = НСтр("ru = 'Windows x86'");
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда 
		Платформа = НСтр("ru = 'Windows x86-64'");
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда 
		Платформа = НСтр("ru = 'Linux x86'");
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда 
		Платформа = НСтр("ru = 'Linux x86-64'");
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86 Тогда 
		Платформа = НСтр("ru = 'macOS x86'");
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64 Тогда 
		Платформа = НСтр("ru = 'macOS x86-64'");
	КонецЕсли;
	
	// Например:
	// веб-клиент Firefox Windows x86
	// тонкий клиент Windows x86-64
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"), Приложение, Платформа);
	
КонецФункции

#КонецОбласти