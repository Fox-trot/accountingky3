﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 1.0.1.3 ИНТЕРФЕЙСА СООБЩЕНИЙ
//
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений.
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/Tariff/App/" + Версия();
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком.
Функция Версия() Экспорт
	
	Возврат "1.0.1.4";
	
КонецФункции

// Возвращает базовый тип для сообщений версии.
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса.
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения.
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияТарификацияИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.ОтправитьОбщиеДанныеПоТарификацииВПрикладнуюИнформационнуюБазу(Пакет()) Тогда
		ОбновитьОбщиеДанныеПоТарификации(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.ОтправитьДанныеПоТарификацииВПриложениеАбонента(Пакет()) Тогда
		ОбновитьДанныеАбонентаПоТарификацииВПриложении(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.УдалитьДанныеПоТарификацииВПриложениеАбонента(Пакет()) Тогда
		УдалитьДанныеПоТарификацииВПриложениеАбонента(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.ОтправитьДанныеПоЛицензиямВПриложениеАбонента(Пакет()) Тогда
		ОбновитьДанныеПоЛицензиям(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.УдалитьДанныеПоЛицензиямВПриложенииАбонента(Пакет()) Тогда
		УдалитьДанныеПоЛицензиям(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет общие (неразделенные) данные по тарифкации в БТС: 
//  - константа "Использовать контроль тарификации",
//  - справочник "Поставщики услуг",
//  - справочник "Услуги".
//
// Параметры:
//  Сообщение - ОбъектXDTO -сообщение.
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - отправитель.
//
Процедура ОбновитьОбщиеДанныеПоТарификации(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияТарификацияРеализация.ОбновитьОбщиеДанныеПоТарификации(ТелоСообщения);
	
КонецПроцедуры

// Обновляет данные абонента (разделенные) по тарификации: подписки на услуги.
// Данные: регистр сведений "Подписки на функциональные услуги"
//
// Параметры:
//  Сообщение - ОбъектXDTO -сообщение.
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - отправитель.
//
Процедура ОбновитьДанныеАбонентаПоТарификацииВПриложении(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияТарификацияРеализация.ОбновитьДанныеАбонентаПоТарификацииВПриложении(ТелоСообщения);
	
КонецПроцедуры

// Удаляет подписки на услуги (разделенные данные) по абоненту.
//
// Параметры:
//  Сообщение - ОбъектXDTO -сообщение.
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - отправитель.
//
Процедура УдалитьДанныеПоТарификацииВПриложениеАбонента(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияТарификацияРеализация.УдалитьДанныеПоТарификацииВПриложениеАбонента(ТелоСообщения);
	
КонецПроцедуры

Процедура ОбновитьДанныеПоЛицензиям(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияТарификацияРеализация.ОбновитьДанныеПоЛицензиям(ТелоСообщения);
	
КонецПроцедуры

Процедура УдалитьДанныеПоЛицензиям(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияТарификацияРеализация.УдалитьДанныеПоЛицензиям(ТелоСообщения);
	
КонецПроцедуры

#КонецОбласти
