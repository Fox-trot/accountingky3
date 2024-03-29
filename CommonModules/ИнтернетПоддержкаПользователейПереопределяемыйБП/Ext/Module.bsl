﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщегоНазначения

// См. ИнтернетПоддержкаПользователейПереопределяемый.ИмяПрограммы.
Функция ИмяПрограммы() Экспорт
	
	ИмяПрограммы = "";
	
	Если ВРег(Метаданные.Имя) = ВРег("БухгалтерияДляКыргызстана") Тогда
		ИмяПрограммы = "AccountingKy";
	ИначеЕсли ВРег(Метаданные.Имя) = ВРег("БухгалтерияДляКыргызстанаБазовая") Тогда
		ИмяПрограммы = "AccountingKyBase";
	КонецЕсли;
	
	Возврат ИмяПрограммы;
	
КонецФункции

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриОпределенииКодаЯзыкаИнтерфейсаКонфигурации.
Процедура ПриОпределенииКодаЯзыкаИнтерфейсаКонфигурации(КодЯзыка, КодЯзыкаВФорматеISO639_1) Экспорт
	
	// БПКР
	Если КодЯзыка = "rus" Тогда
		КодЯзыкаВФорматеISO639_1 = "ru";
	ИначеЕсли КодЯзыка = "english" Тогда
		КодЯзыкаВФорматеISO639_1 = "en";
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаСобытийБиблиотеки

// Реализует обработку события сохранения в информационной базе данных
// аутентификации пользователя Интернет-поддержки - логина и пароля
// для подключения к сервисам Интернет-поддержки.
//
// Параметры:
//  ДанныеПользователя - Структура, Неопределено - структура с полями. Если в метод передано значение
//                       Неопределено, данные аутентификации были удалены.
//    * Логин - Строка - логин пользователя;
//    * Пароль - Строка - пароль пользователя;
//
Процедура ПриИзмененииДанныхАутентификацииИнтернетПоддержки(ДанныеПользователя) Экспорт
	
	// В режиме сервиса не проверяем.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	// Добавление доступа пользователю к сервисам.
	Если ДанныеПользователя = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСКонтрагентами.ЗарегистрироватьОрганизациюНаСервере();	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//#Область ИнтернетПоддержкаПользователейБП

//#Область ОбработкаНовостей

//// Возвращает значение варианта отбора по ленте новостей
//// Подробнее в описании метода Справочник.Новости.ПолучитьСписокНовостей()
////
//Функция ВариантОтбораПоЛентеНовостей() Экспорт
//	
//	Возврат 1;
//	
//КонецФункции

//Функция КоличествоКонтекстныхНовостей() Экспорт
//	
//	Возврат 50;
//	
//КонецФункции

//// Функция - возвращает ссылку на элемент справочника "Ленты новостей"
//// 
//// Возвращаемое значение:
////  СправочникСсылка.ЛентыНовостей - ссылка на справочник
////
//Функция ЛентаНовостейЧтоНового() Экспорт
//	
//	Возврат ОбработкаНовостейПовтИсп.ПолучитьЛентуНовостейПоКоду("WhatIsNew");
//	
//КонецФункции

//// Функция - Порядок контекстных новостей
//// 
//// Возвращаемое значение:
////  Строка - перечисление через запятую порядка сортировки новостей
////
//Функция ПорядокКонтекстныхНовостей() Экспорт
//	
//	Возврат  "Прочтена Возр, ДатаПубликации Убыв, Важность Убыв";
//	
//КонецФункции

//// Процедура - Снятие выделения элементов дерева
////
//// Параметры:
////  СтрокаДерева - СтрокаДереваЗначений - строка дерева значений, с которого нужно снять пометку "Прочитано"
////
//Процедура СнятиеВыделенияЭлементовДерева(СтрокаДерева) Экспорт
//	
//	СписокЭлементовДерева = СтрокаДерева.ПолучитьЭлементы();
//	Для Каждого ЭлементДерева Из СписокЭлементовДерева Цикл
//		
//		ЭлементДерева.ВыделеннаяСтрока = Ложь;
//		СнятиеВыделенияЭлементовДерева(ЭлементДерева);
//		
//	КонецЦикла;
//	
//КонецПроцедуры

//#КонецОбласти

//#КонецОбласти
