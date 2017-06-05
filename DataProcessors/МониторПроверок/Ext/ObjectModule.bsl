﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Перем мПустойЦвет;
Перем мЦветШапки;
Перем мЦветОсобогоЗначения;
Перем мШиринаКолонокПоУмолчанию;
Перем мМакет;
Перем мТипЧисло;
Перем мТипСтрока;
Перем мТипДата;
Перем мТипБулево;
Перем мТипРезультатЗапроса;

#Область СлужебныеПроцедурыИФункции

// Функция - Выполнить запрос
//
// Параметры:
//  Запрос	 - ЗапросОбъект	 - объект типа запрос для выполнения запроса
// 
// Возвращаемое значение:
//   ТабличныйДокумент - результат выполненного запроса в табличном документе
//
Функция ВыполнитьЗапрос(Запрос) Экспорт
	Попытка
		МассивРезультатов = Запрос.ВыполнитьПакет();
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки;
	
	Моксель = ПолучитьРезультатыЗапросов(МассивРезультатов);
	Возврат Моксель;
КонецФункции

Функция ПолучитьРезультатыЗапросов(МассивРезультатов)
	Если МассивРезультатов.Количество() > 1 Тогда
		Моксель = ЗаполнитьМоксельПакета(МассивРезультатов);
	Иначе
		Моксель = ЗаполнитьМоксель(МассивРезультатов[0]);
	КонецЕсли;
	Возврат Моксель;
КонецФункции

Функция ЗаполнитьМоксельПакета(МассивРезультатов)
	СловоЗапрос = "Запрос";
	Моксель = Новый ТабличныйДокумент();
	ЗаголовокЗапроса = мМакет.ПолучитьОбласть("ЗаголовокЗапроса");
	ЗапросНаУдаление = мМакет.ПолучитьОбласть("ЗапросНаУдаление");
	ВерхняяГраница = МассивРезультатов.Количество() - 1;
	Для Индекс = 0 по ВерхняяГраница Цикл
		Результат = МассивРезультатов[Индекс];
		НомерЗапроса = Индекс + 1;
		ЗаголовокЗапроса.Параметры.НомерЗапроса = НомерЗапроса;
		Если Результат = Неопределено Тогда
			Моксель.Вывести(ЗаголовокЗапроса);
			Моксель.Вывести(ЗапросНаУдаление);
		Иначе
			Моксель.Вывести(ЗаголовокЗапроса);
			Моксель.НачатьГруппуСтрок(СловоЗапрос + Строка(НомерЗапроса), Ложь);
			Моксель.Вывести(ЗаполнитьМоксель(Результат));
			Моксель.ЗакончитьГруппуСтрок();
		КонецЕсли;
	КонецЦикла;
	Возврат Моксель;
КонецФункции

Функция ЗаполнитьМоксель(Результат)
	
	КолонкиРезультата = Результат.Колонки;
	КоличествоКолонок = КолонкиРезультата.Количество();
	Моксель           = Новый ТабличныйДокумент(); 
	Заголовок         = Новый ТабличныйДокумент();
	Ячейка            = мМакет.ПолучитьОбласть("ЯчейкаРезультата");
	Для каждого Колонка из КолонкиРезультата Цикл
		Ячейка.Параметры.Содержание = Колонка.Имя;
		Заголовок.Присоединить(Ячейка);
	КонецЦикла;
	ОбластьЗаголовка = Заголовок.Область(1, 1, 1, КоличествоКолонок);
	ОбластьЗаголовка.Шрифт = Новый Шрифт(ОбластьЗаголовка.Шрифт, , , Истина);
	ОбластьЗаголовка.ЦветФона = мЦветШапки;
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 3);
	ОбластьЗаголовка.Обвести(Линия, Линия, Линия, Линия);
	Моксель.Вывести(Заголовок);
	Моксель.Вывести(ВывестиПлоско(Результат.Выбрать(ОбходРезультатаЗапроса.Прямой), Ячейка, КоличествоКолонок - 1));
	Моксель.ФиксацияСверху = 1;
	Возврат Моксель;
КонецФункции

Функция ВывестиПлоско(Выборка, Ячейка, ГраничныйИндекс)
	Таблица = Новый ТабличныйДокумент();
	Пока Выборка.Следующий() Цикл
		Запись = Новый ТабличныйДокумент();
		Для Индекс = 0 по ГраничныйИндекс Цикл
			ФорматироватьЯчейку(Ячейка, Выборка[Индекс]);
			Запись.Присоединить(Ячейка);
		КонецЦикла;
		Таблица.Вывести(Запись);
	КонецЦикла;
	Возврат Таблица;
КонецФункции

Процедура ФорматироватьЯчейку(Ячейка, Значение)
	Область = Ячейка.Область();
	Область.ЦветТекста = мПустойЦвет;
	Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Ячейка;
	Если Значение = Null Тогда
		Ячейка.Параметры.Содержание      = "NULL";
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста               = мЦветОсобогоЗначения;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипЧисло Тогда 
		Ячейка.Параметры.Содержание      = ?(Значение = 0, "0", Значение);
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Право;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипСтрока Тогда
		Ячейка.Параметры.Содержание      = Значение;
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Лево;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипБулево Тогда
		Ячейка.Параметры.Содержание      = Значение;
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Центр;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипРезультатЗапроса Тогда
		Ячейка.Параметры.Содержание     = "<РЕЗУЛЬТАТ ЗАПРОСА>";
		Ячейка.Параметры.Расшифровка    = ЗаполнитьМоксель(Значение);
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста              = мЦветОсобогоЗначения;
	Иначе
		Ячейка.Параметры.Содержание     = Строка(Значение);
		Ячейка.Параметры.Расшифровка    = Значение;
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

// -----------------------------
мПустойЦвет          = Новый Цвет();
мЦветШапки           = WebЦвета.СеребристоСерый; 
мЦветОсобогоЗначения = WebЦвета.ЦианНейтральный;
мМакет = Обработки.МониторПроверок.ПолучитьМакет("МакетРезультата");
мТипЧисло            = Тип("Число");
мТипСтрока           = Тип("Строка");
мТипДата             = Тип("Дата");
мТипБулево           = Тип("Булево");
мТипРезультатЗапроса = Тип("РезультатЗапроса");

#КонецЕсли