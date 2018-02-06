﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Получить номенклатуру по штрихкоду
//
// Параметры:
//  ДанныеШтрихкода	 - Структура -
//		*Штрихкод - Строка - Штрихкод номенклатуры
// 
// Возвращаемое значение:
//  СправочникСсылка.Номенклатура или Неопределено
//
Функция ПолучитьНоменклатуруПоШтрихкоду(ДанныеШтрихкода) Экспорт
	
	Штрихкод = ДанныеШтрихкода.Штрихкод;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Штрихкод = &Штрихкод";
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Номенклатура;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Функция - Получить штрихкод по номенклатуре
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - Номенклатура, штрихкод которой нужно получить
// 
// Возвращаемое значение:
//  Штрихкод - Строка
//
Функция ПолучитьШтрихкодПоНоменклатуре(Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
		|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура,
		|	Штрихкод";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Штрихкод;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ГенерацияШтрихкодов

// Функция вычисляет контрольный символ кода EAN
//
// Параметры:
//  ШтрихКод     - штрихкод (без контрольной цифры)
//  Тип          - тип штрихкода: 13 - EAN13, 8 - EAN8
//
// Возвращаемое значение:
//  Контрольный символ штрихкода
//
Функция КонтрольныйСимволEAN(ШтрихКод, Тип) Экспорт
	
	Четн   = 0;
	Нечетн = 0;
	
	КоличествоИтераций = ?(Тип = 13, 6, 4);
	
	Для Индекс = 1 По КоличествоИтераций Цикл
		Если (Тип = 8) и (Индекс = КоличествоИтераций) Тогда
		Иначе
			Четн   = Четн   + Сред(ШтрихКод, 2 * Индекс, 1);
		КонецЕсли;
		Нечетн = Нечетн + Сред(ШтрихКод, 2 * Индекс - 1, 1);
	КонецЦикла;
	
	Если Тип = 13 Тогда
		Четн = Четн * 3;
	Иначе
		Нечетн = Нечетн * 3;
	КонецЕсли;
	
	КонтЦифра = 10 - (Четн + Нечетн) % 10;
	
	Возврат ?(КонтЦифра = 10, "0", Строка(КонтЦифра));
	
КонецФункции // КонтрольныйСимволEAN()

Функция ПолучитьМаксимальноеЗначениеКодаШтрихкодаЧислом(ПрефиксШтучногоТовара = "0", ПрефиксВнутреннегоШтрихкода = "00") Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	МАКСИМУМ(ПОДСТРОКА(ШтрихкодыНоменклатуры.Штрихкод, 5, 8)) КАК Код
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Штрихкод ПОДОБНО &ШаблонШтрихкод"
	);
	
	ШаблонШтрихкод = "2" + ПрефиксШтучногоТовара + ПрефиксВнутреннегоШтрихкода + "_________";
	Запрос.УстановитьПараметр("ШаблонШтрихкод", ШаблонШтрихкод);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ОписаниеТипаЧисла = Новый ОписаниеТипов("Число");
	ЗначениеКодаЧислом = ОписаниеТипаЧисла.ПривестиЗначение(Выборка.Код);
	
	Возврат ЗначениеКодаЧислом;
	
КонецФункции // ПолучитьМаксимальноеЗначениеКодаШтрихкодаЧислом()

Функция ПолучитьШтрихкодПоКоду(Код, ПрефиксШтучногоТовара = "0", ПрефиксВнутреннегоШтрихкода = "00") Экспорт

	Штрихкод = "2" + ПрефиксШтучногоТовара + ПрефиксВнутреннегоШтрихкода + Формат(Код, "ЧЦ=8; ЧВН=; ЧГ=");
	Штрихкод = Штрихкод + КонтрольныйСимволEAN(ШтрихКод, 13);
	
	Возврат Штрихкод;

КонецФункции // ПолучитьШтрихкодПоКоду()

// Функция осуществляет формирование штрихкода EAN13 для
// штучного товара
//
// Параметры:
//  ПрефиксШтучногоТовара       – Строка
//  ПрефиксВнутреннегоШтрихкода – Строка
//  МаксимальныйКод             – Число
//
// Возвращаемое значение:
//  Строка
//
Функция СформироватьШтрихкодEAN13(ПрефиксШтучногоТовара = "0", ПрефиксВнутреннегоШтрихкода = "00", МаксимальныйКод = 99999999) Экспорт

	Код = Мин(ПолучитьМаксимальноеЗначениеКодаШтрихкодаЧислом(ПрефиксШтучногоТовара, ПрефиксВнутреннегоШтрихкода) + 1, МаксимальныйКод);

	Возврат ПолучитьШтрихкодПоКоду(Код, ПрефиксШтучногоТовара, ПрефиксВнутреннегоШтрихкода);

КонецФункции

#КонецОбласти

#КонецЕсли