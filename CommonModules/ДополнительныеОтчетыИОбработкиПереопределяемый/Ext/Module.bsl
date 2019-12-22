﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
// В разделы необходимо добавить метаданные тех разделов,
// в которых размещены команды вызова.
// Для начальной страницы указать ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы.
//
// Параметры:
//   Разделы - Массив - разделы, в которых размещены команды вызова дополнительных обработок.
//       * ОбъектМетаданных: Подсистема - метаданные раздела (подсистемы).
//       * Строка - для начальной страницы.
//
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт
	
	ДополнительныеОтчетыИОбработкиПереопределяемыйБП.ОпределитьРазделыСДополнительнымиОбработками(Разделы);
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
// В Разделы необходимо добавить метаданные тех разделов, 
// в которых размещены команды вызова.
// Для начальной страницы указать ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы.
//
// Параметры:
//   Разделы - Массив - разделы, в которых размещены команды вызова дополнительных отчетов.
//       * ОбъектМетаданных: Подсистема - метаданные раздела (подсистемы).
//       * Строка - для начальной страницы.
//
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	ДополнительныеОтчетыИОбработкиПереопределяемыйБП.ОпределитьРазделыСДополнительнымиОтчетами(Разделы);		
	
КонецПроцедуры

#КонецОбласти
