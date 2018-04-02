﻿#Область ПрограммныйИнтерфейс

// Устанавливает или изменяет "быстрый" отбор динамического списка (по значениям отбора, указанным в реквизитах формы).
//
// Параметры:
// Форма - УправляемаяФорма - форма, у которой есть реквизит динамический список с именем Список.
// ИмяПоля - Строка - имя отбора, у формы должны быть реквизиты с именами Отбор<ИмяПоля> и Отбор<ИмяПоля>Использование.
//
Процедура УстановитьБыстрыйОтбор(Форма, ИмяПоля, ВидСравнения = Неопределено) Экспорт
	
	ПравоеЗначение = Форма["Отбор" + ИмяПоля];
	Использование  = Форма["Отбор" + ИмяПоля + "Использование"];
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		Форма.Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяПоля);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Форма.Список.КомпоновщикНастроек.Настройки.Отбор,
		ИмяПоля,
		ПравоеЗначение,
		ВидСравнения,
		,
		Использование);
	
КонецПроцедуры

#КонецОбласти
