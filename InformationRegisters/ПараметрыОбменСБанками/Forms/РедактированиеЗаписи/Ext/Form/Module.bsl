﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НастройкаОбмена) Тогда
		ТекущаяЗапись = РегистрыСведений.ПараметрыОбменСБанками.СоздатьМенеджерЗаписи();
		ТекущаяЗапись.НастройкаОбмена = Параметры.НастройкаОбмена;
		ТекущаяЗапись.Прочитать();
		
		// Для новой настройки записей в регистре еще нет
		Если Не ТекущаяЗапись.Выбран() Тогда
			ТекущаяЗапись.НастройкаОбмена = Параметры.НастройкаОбмена;
		КонецЕсли;
	
		ЗначениеВРеквизитФормы(ТекущаяЗапись, "Запись");
		
		РеквизитыНастройкиОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Параметры.НастройкаОбмена, "ПрограммаБанка, ИспользуетсяКриптография");
		ПрограммаБанка = РеквизитыНастройкиОбмена.ПрограммаБанка;
		ИспользуетсяКриптография = РеквизитыНастройкиОбмена.ИспользуетсяКриптография;
		
	КонецЕсли;
	
	Элементы.Журналирование.Видимость = ПрограммаБанка =  Перечисления.ПрограммыБанка.СбербанкОнлайн
		ИЛИ ПрограммаБанка =  Перечисления.ПрограммыБанка.ОбменЧерезВК;
		
	Элементы.КаталогДляЖурналирования.Видимость = ТекущаяЗапись.ИспользоватьЖурналирование;
	
	Элементы.Предупреждение.Видимость = Ложь;
	
	Элементы.ВебПредупреждение.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Элементы.КаталогДляЖурналирования.КнопкаВыбора = Ложь;
		Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляРаботыСФайламиПриОткрытии", ЭтотОбъект);
		НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
		Если ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн") Тогда
			Элементы.ВебПредупреждение.Видимость = Запись.ИспользоватьЖурналирование;
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Запись.ИспользоватьЖурналирование И Не ЗначениеЗаполнено(Запись.КаталогДляЖурналирования) Тогда
		ТекстСообщения = НСтр("ru = 'Укажите каталог для журналирования.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.КаталогДляЖурналирования", , Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененаНастройкаОбменСБанками", Запись.НастройкаОбмена);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьЖурналированиеПриИзменении(Элемент)
	
	Если Запись.ИспользоватьЖурналирование Тогда
		#Если ВебКлиент Тогда
			Если ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
				И НЕ ИспользуетсяКриптография Тогда
				Оповещение = Новый ОписаниеОповещения("ПослеПопыткиПодключенияРасширенияДляРаботыСФайлами", ЭтотОбъект);
				НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
				Запись.ИспользоватьЖурналирование = Ложь;
			КонецЕсли;
		#КонецЕсли
	КонецЕсли;
	
	Элементы.КаталогДляЖурналирования.Видимость = Запись.ИспользоватьЖурналирование;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогДляЖурналированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог для сохранения файлов журнала.'");
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораКаталога", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьРасширение(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеПринудительнойУстановкиРасширения", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПринудительнойУстановкиРасширения(ДополнительныеПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеПроверкиУстановкиРасширения", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиУстановкиРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Элементы.Предупреждение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияРасширенияДляРаботыСФайламиПриОткрытии(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Элементы.КаталогДляЖурналирования.КнопкаВыбора = Истина;
	ИначеЕсли ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
		И НЕ ИспользуетсяКриптография И Запись.ИспользоватьЖурналирование Тогда
		Элементы.Предупреждение.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораКаталога(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись.КаталогДляЖурналирования = ВыбранныеФайлы.Получить(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПопыткиПодключенияРасширенияДляРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Запись.ИспользоватьЖурналирование = Истина;
		Элементы.КаталогДляЖурналирования.Видимость = Истина;
		Элементы.ВебПредупреждение.Видимость = Истина;
	Иначе
		ТекстВопроса = НСтр("ru = 'Необходимо установить расширение для работы с файлами. Продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаОбУстановкеРасширения", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОбУстановкеРасширения(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеПопыткиУстановкиРасширенияДляРаботыСФайлами", ЭтотОбъект);
		НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПопыткиУстановкиРасширенияДляРаботыСФайлами(ДополнительныеПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляРаботыСФайлами", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияРасширенияДляРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Запись.ИспользоватьЖурналирование = Истина;
		Элементы.КаталогДляЖурналирования.Видимость = Истина;
		Элементы.ВебПредупреждение.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

