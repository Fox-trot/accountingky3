﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для подсистемы ПоставляемыеДанные
// общий модуль ПоставляемыеДанныеПереопределяемый.
//

// Зарегистрировать обработчики поставляемых данных.
//
// При получении уведомления о доступности новых общих данных, вызывается процедуры.
// ДоступныНовыеДанные модулей, зарегистрированных через ПолучитьОбработчикиПоставляемыхДанных.
// В процедуру передается Дескриптор - ОбъектXDTO Descriptor.
// 
// В случае, если ДоступныНовыеДанные устанавливает аргумент Загружать в значение Истина, 
// данные загружаются, дескриптор и путь к файлу с данными передаются в процедуру.
// ОбработатьНовыеДанные. Файл будет автоматически удален после завершения процедуры.
// Если в менеджере сервиса не был указан файл - значение аргумента равно Неопределено.
//
// Параметры: 
//   Обработчики - ТаблицаЗначений - таблица для добавления обработчиков с колонками:
//     * ВидДанных - Строка - код вида данных, обрабатываемый обработчиком.
//     * КодОбработчика - Строка - будет использоваться при восстановлении обработки данных после сбоя.
//     * Обработчик - ОбщийМодуль - модуль, содержащий следующие процедуры:
//		  	ДоступныНовыеДанные(Дескриптор, Загружать) Экспорт  
//			ОбработатьНовыеДанные(Дескриптор, ПутьКФайлу) Экспорт
//			ОбработкаДанныхОтменена(Дескриптор) Экспорт
//
Процедура ПолучитьОбработчикиПоставляемыхДанных(Обработчики) Экспорт
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПолучитьОбработчикиПоставляемыхДанных(Обработчики);
	// Конец ИнтернетПоддержкаПользователей
	
КонецПроцедуры

#КонецОбласти
