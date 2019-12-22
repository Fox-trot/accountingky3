﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ОбработчикиСлужебныхСобытий

// Вызывается перед выгрузкой данных.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
Процедура ПередВыгрузкойДанных(Контейнер) Экспорт
	
	ИмяФайла = Контейнер.СоздатьПроизвольныйФайл("xml", ТипДанныхДляВыгрузкиЗагрузкиВерсийПодсистем());
	
	ВерсииПодсистем = Новый Структура();
	
	ОписанияПодсистем = СтандартныеПодсистемыПовтИсп.ОписанияПодсистем().ПоИменам;
	Для Каждого ОписаниеПодсистемы Из ОписанияПодсистем Цикл
		ВерсииПодсистем.Вставить(ОписаниеПодсистемы.Ключ, ОбновлениеИнформационнойБазы.ВерсияИБ(ОписаниеПодсистемы.Ключ));
	КонецЦикла;
	
	ВыгрузкаЗагрузкаДанных.ЗаписатьОбъектВФайл(ВерсииПодсистем, ИмяФайла);
	Контейнер.УстановитьКоличествоОбъектов(ИмяФайла, ВерсииПодсистем.Количество());
	
КонецПроцедуры

// Вызывается перед загрузкой данных.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ПередЗагрузкойДанных(Контейнер) Экспорт
	
	ИмяФайла = Контейнер.ПолучитьПроизвольныйФайл(ТипДанныхДляВыгрузкиЗагрузкиВерсийПодсистем());
	
	ВерсииПодсистем = ВыгрузкаЗагрузкаДанных.ПрочитатьОбъектИзФайла(ИмяФайла);
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого ВерсияПодсистемы Из ВерсииПодсистем Цикл
			ОбновлениеИнформационнойБазыСлужебный.УстановитьВерсиюИБ(ВерсияПодсистемы.Ключ, ВерсияПодсистемы.Значение, (ВерсияПодсистемы.Ключ = Метаданные.Имя));
			ОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса.ПриОтметкеРегистрацииОтложенныхОбработчиковОбновления(ВерсияПодсистемы.Ключ, Истина, Истина);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипДанныхДляВыгрузкиЗагрузкиВерсийПодсистем()
	
	Возврат "1cfresh\ApplicationData\SubstemVersions";
	
КонецФункции

#КонецОбласти
