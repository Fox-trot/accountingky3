﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
// В Разделы необходимо добавить метаданные тех разделов,
// в которых размещены команды вызова.
// Для начальной страницы указать ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных обработок.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для начальной страницы.
//
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт

	Разделы.Добавить(Метаданные.Подсистемы.ДенежныеСредства);
	Разделы.Добавить(Метаданные.Подсистемы.ПокупкаИПродажа);
	Разделы.Добавить(Метаданные.Подсистемы.Запасы);
	Разделы.Добавить(Метаданные.Подсистемы.Зарплата);
	Разделы.Добавить(Метаданные.Подсистемы.ОсновныеСредства);
	Разделы.Добавить(Метаданные.Подсистемы.Отчеты);
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
// В Разделы необходимо добавить метаданные тех разделов, 
// в которых размещены команды вызова.
// Для начальной страницы указать ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных отчетов.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для начальной страницы.
//
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.ДенежныеСредства);
	Разделы.Добавить(Метаданные.Подсистемы.ПокупкаИПродажа);
	Разделы.Добавить(Метаданные.Подсистемы.Запасы);
	Разделы.Добавить(Метаданные.Подсистемы.Зарплата);
	Разделы.Добавить(Метаданные.Подсистемы.ОсновныеСредства);
	Разделы.Добавить(Метаданные.Подсистемы.Отчеты);
	
КонецПроцедуры

#КонецОбласти
