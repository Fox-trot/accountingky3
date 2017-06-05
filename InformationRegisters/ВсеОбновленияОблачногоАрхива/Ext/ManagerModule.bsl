﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список доступных значений для поля "ВидОбновления".
//
// Возвращаемое значение:
//   Массив - список доступных значений.
//
Функция ПолучитьЗначенияДопустимыхВидовОбновления() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Загрузка информации об актуальных версиях агента копирования");
	Результат.Добавить("Загрузка информации об активированных агентах копирования");
	Результат.Добавить("Загрузка списка резервных копий");
	Результат.Добавить("Загрузка информации о состоянии использования облачного архива");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли