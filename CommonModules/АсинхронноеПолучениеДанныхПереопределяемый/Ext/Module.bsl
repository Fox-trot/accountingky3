﻿
#Область ПрограммныйИнтерфейс

// Вызывается при формировании списка доступных возвращаемых данных и при получении данных. 
// Определяет список возвращаемых данных, подключенных к подсистеме.
//
// Параметры:
// - ДоступныеВозвращаемыеДанные - Соответствие с полями:
//     * Ключ - идентификатор данных.
//     * Значение - Структура - описание данных (см. АсинхронноеПолучениеДанных.НовыйОписаниеВозвращаемыхДанных). 
//
Процедура УстановитьДоступныеВозвращаемыеДанные(ДоступныеВозвращаемыеДанные) Экспорт
    
    
	
КонецПроцедуры

// Вызывается при первичной обработке входящего запроса. Позволяет выполнить прикладную логику,
// связанную с валидацией входящего запроса и при необходимости отказать в обработке запроса.
//
// Параметры:
//   ИдентификаторДанных - Строка - идентификатор данных. Может быть переопределено при обработке.
//               Указывается в качестве имени файла, возвращаемом в результате.
//   Параметры - ДвоичныеДанные - переданные параметры получения данных.
//   Отказ - Булево - Возвращаемый параметр. Признак отказа в авторизации. При отказе в авторизации устанавливать в Отказ = Истина.
//   СообщениеОбОшибке - Строка - Возвращаемый параметр. Текст сообщения об ошибке при отказе в авторизации. 
//
Процедура АвторизоватьЗапрос(ИдентификаторДанных, Параметры, Отказ, СообщениеОбОшибке) Экспорт
	

	
КонецПроцедуры

#КонецОбласти 