﻿
#Область ПрограммныйИнтерфейс

// Позволяет дополнить базовую коллекцию дополнительными регистрами.
//
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    СоответствиеРегистров - Соответствие - соответствие с данными:
//        * Ключ     - ОбъектМетаданных - регистр как объект метаданных.
//        * Значение - Строка           - имя поля регистратора.
//
Процедура ПриОпределенииРегистровСДвижениями(Документ, СоответствиеРегистров) Экспорт
	
	
	
КонецПроцедуры

// Позволяет рассчитать количество записей для дополнительных наборов, добавленных процедурой
// ПриОпределенииРегистровСДвижениями.
//
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    РассчитанноеКоличество - Соответствие - соответствие с данными:
//        * Ключ     - Строка - полное имя регистра (вместо точек используется символ подчеркивания).
//        * Значение - Число  - рассчитанное количество записей.
//
Процедура ПриРасчетеКоличестваЗаписей(Документ, РассчитанноеКоличество) Экспорт
	
	
	
КонецПроцедуры

// Позволяет подготовить наборы данных СКД в соответствии с требованиями отличающимися от стандартных.
//
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    ОсновнаяИнформация - Структура - структура с ключами:
//        * ИмяРегистра             - Строка           - имя регистра.
//        * ВидРегистра             - Строка           - вид регистра (Накопления, Расчета, Бухгалтерии, Сведений).
//        * ЛокализацияВидРегистра  - Строка           - локализация вида регистра (Накопления, Расчета, Бухгалтерии, Сведений).
//        * ПредставлениеРегистра   - Строка           - пользовательское представление регистра.
//        * ПолеРегистратора        - Строка           - имя поля регистратора (по умолчанию "Регистратор")
//        * ДополнительнаяНумерация - Булево           - признак дополнительной нумерации.
//        * ДвижениеДокумента       - ОбъектМетаданных - регистр как объект метаданных.
//
Процедура ПриПодготовкеНабораДанных(Документ, ОсновнаяИнформация) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
