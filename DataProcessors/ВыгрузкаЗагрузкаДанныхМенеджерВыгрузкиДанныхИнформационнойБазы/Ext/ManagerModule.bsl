﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Выгружает данные информационной базы.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ВыгрузитьДанныеИнформационнойБазы(Контейнер, Обработчики, Сериализатор) Экспорт
	
	ВыгружаемыеТипы = Контейнер.ПараметрыВыгрузки().ВыгружаемыеТипы;
	ИсключаемыеТипы = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	
	ТекущийПотокЗаписиПересоздаваемыхСсылок = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиПересоздаваемыхСсылок.Создать();
	ТекущийПотокЗаписиПересоздаваемыхСсылок.Инициализировать(Контейнер, Сериализатор);
	
	ТекущийПотокЗаписиСопоставляемыхСсылок = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиСопоставляемыхСсылок.Создать();
	ТекущийПотокЗаписиСопоставляемыхСсылок.Инициализировать(Контейнер, Сериализатор);
	
	Для Каждого ОбъектМетаданных Из ВыгружаемыеТипы Цикл
		
		Если ИсключаемыеТипы.Найти(ОбъектМетаданных) <> Неопределено Тогда
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ВыгрузкаОбъектаПропущена'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Информация,
				ОбъектМетаданных,
				,
				СтрШаблон(НСтр("ru = 'Выгрузка данных объекта метаданных %1 пропущена, т.к. он включен в
                          |список объектов метаданных, исключаемых из выгрузки и загрузки данных'", ОбщегоНазначения.КодОсновногоЯзыка()),
					ОбъектМетаданных.ПолноеИмя()));
			
			Продолжить;
			
		КонецЕсли;
		
		МенеджерВыгрузкиОбъекта = Создать();
		
		МенеджерВыгрузкиОбъекта.Инициализировать(
			Контейнер,
			ОбъектМетаданных,
			Обработчики,
			Сериализатор,
			ТекущийПотокЗаписиПересоздаваемыхСсылок,
			ТекущийПотокЗаписиСопоставляемыхСсылок);
		
		МенеджерВыгрузкиОбъекта.ВыгрузитьДанные();
		
		МенеджерВыгрузкиОбъекта.Закрыть();
		
	КонецЦикла;
	
	ТекущийПотокЗаписиПересоздаваемыхСсылок.Закрыть();
	ТекущийПотокЗаписиСопоставляемыхСсылок.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
