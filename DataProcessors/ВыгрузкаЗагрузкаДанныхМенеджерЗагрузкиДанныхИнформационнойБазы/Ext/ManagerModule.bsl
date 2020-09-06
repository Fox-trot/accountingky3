﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Загружает данные информационной базы.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Обработчики - ОбщийМодуль, ОбработкаМенеджер -
//
Функция ЗагрузитьДанныеИнформационнойБазы(Контейнер, Обработчики) Экспорт
	
	ЗагружаемыеТипы = Контейнер.ПараметрыЗагрузки().ЗагружаемыеТипы;
	ИсключаемыеТипы = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	
	МенеджерЗагрузки = Создать();
	МенеджерЗагрузки.Инициализировать(Контейнер, ЗагружаемыеТипы, ИсключаемыеТипы, Обработчики);
	МенеджерЗагрузки.ЗагрузитьДанные();
	
	Возврат МенеджерЗагрузки.ТекущийПотокЗаменыСсылок();
	
КонецФункции

#КонецОбласти

#КонецЕсли
