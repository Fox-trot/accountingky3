﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
//
// Возвращаемое значение:
//  Массив - массив структур (варианты отчета).
Функция ВариантыНастроек() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый Структура("Имя, Представление", "ДвижениеТоваров", НСтр("ru = 'Движение товаров'")));
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ДвижениеТоваров");
	НастройкиВарианта.Описание = НСтр("ru = 'Движение товаров'");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	
	Возврат Результат;
													
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Движение товаров %1'"), БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
КонецФункции

Процедура ДобавитьРесурсыОтчета(Элемент, ПараметрыОтчета)
	
	ГруппаНачОст = Элемент.Выбор.Элементы.Добавить(тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаНачОст.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаНачОст.Заголовок = "Нач ост";
	
	ГруппаПоступление = Элемент.Выбор.Элементы.Добавить(тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоступление.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаПоступление.Заголовок = "Поступление";
	
	ГруппаВыбытие = Элемент.Выбор.Элементы.Добавить(тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаВыбытие.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаВыбытие.Заголовок = "Выбытие";
	
	ГруппаКонОст = Элемент.Выбор.Элементы.Добавить(тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаКонОст.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаКонОст.Заголовок = "Кон. ост";
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаНачОст,			"" + ИмяПоказателя + "НачОст");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоступление,	"" + ИмяПоказателя + "Поступление");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаВыбытие,		"" + ИмяПоказателя + "Выбытие");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКонОст,			"" + ИмяПоказателя + "КонОст");
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Таблица, "ВертикальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Конец);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	// Колонка "показатели"
	Если КоличествоПоказателей > 1 Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "Показатели";
		Колонка.Использование = Истина;
		
		ГруппаПоказатели = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, "КонецПериода", Новый Граница(КонецДня(ПараметрыОтчета.КонецПериода), ВидГраницы.Включая));
	КонецЕсли;
	
	СтруктураСчетов = СтруктураСчетов(БухгалтерскиеОтчеты.СчетаУчетаТоваров());
	
	Для Каждого Счета Из СтруктураСчетов Цикл
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, Счета.Ключ, Счета.Значение);
		
	КонецЦикла;
	
	ГоризонтальнаяГруппировка = Таблица.Строки;
	ВертикальнаяГруппировка = Таблица.Колонки;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		
		Если ПараметрыОтчета.ВертикальнаяГруппировкаПоСкладам И ПолеВыбраннойГруппировки.Поле = "Склад" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Группировка = ГоризонтальнаяГруппировка.Добавить();
			ГоризонтальнаяГруппировка = Группировка.Структура;
			БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
		КонецЕсли;
	КонецЦикла;
	
	Группировка = ВертикальнаяГруппировка.Добавить();
	
	Если ПараметрыОтчета.ВертикальнаяГруппировкаПоСкладам Тогда
		
		Группировка.Имя = "Склад";
		
		ДанныеГруппировки = Новый Структура();
		ДанныеГруппировки.Вставить("Использование", 	Истина);
		ДанныеГруппировки.Вставить("Поле", 				"Склад");
		ДанныеГруппировки.Вставить("Представление", 	"Склад");
		ДанныеГруппировки.Вставить("ТипГруппировки", 	0);
		
		БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ДанныеГруппировки, Группировка);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Группировка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Начало);
	Иначе
		
		Группировка = ВертикальнаяГруппировка.Добавить();
		Группировка.Имя = "Колонки";
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Группировка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
	КонецЕсли;
	
	
	ДобавитьРесурсыОтчета(Группировка, ПараметрыОтчета);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

// Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Сумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	Для Каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Вставить("Показатель" + Показатель, Ложь);
	КонецЦикла;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ВертикальнаяГруппировкаПоСкладам" , Ложь);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("НаборПоказателей"     , ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураСчетов(СчетаУчетаТоваров)

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйВидыСубконто.Ссылка КАК Счет,
	               |	ХозрасчетныйВидыСубконто.ВидСубконто,
	               |	ХозрасчетныйВидыСубконто.Суммовой
	               |ПОМЕСТИТЬ ВидыСубконто
	               |ИЗ
	               |	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	               |ГДЕ
	               |	ХозрасчетныйВидыСубконто.Ссылка В(&СчетаУчетаТоваров)
	               |	И ХозрасчетныйВидыСубконто.ВидСубконто = &ВидСубконтоСклады
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Счет
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВидыСубконто.Счет КАК Счет
	               |ИЗ
	               |	ВидыСубконто КАК ВидыСубконто
	               |ГДЕ
	               |	ВидыСубконто.Суммовой = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВидыСубконто.Счет
	               |ИЗ
	               |	ВидыСубконто КАК ВидыСубконто
	               |ГДЕ
	               |	ВидыСубконто.Суммовой = ЛОЖЬ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Хозрасчетный.Ссылка КАК Счет
	               |ИЗ
	               |	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	               |ГДЕ
	               |	НЕ Хозрасчетный.Ссылка В
	               |				(ВЫБРАТЬ
	               |					ВидыСубконто.Счет КАК Счет
	               |				ИЗ
	               |					ВидыСубконто КАК ВидыСубконто)
	               |	И Хозрасчетный.Ссылка В(&СчетаУчетаТоваров)";
				   
	Запрос.УстановитьПараметр("СчетаУчетаТоваров", СчетаУчетаТоваров);
	Запрос.УстановитьПараметр("ВидСубконтоСклады", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СтруктураСчетов = Новый Структура;
	
	СтруктураСчетов.Вставить("СчетаУчетаСкладИНоменклатура", Результат[1].Выгрузить().ВыгрузитьКолонку("Счет"));
	
	СтруктураСчетов.Вставить("СчетаУчетаСкладТолькоКоличествоИНоменклатура", Результат[2].Выгрузить().ВыгрузитьКолонку("Счет"));
	
	СтруктураСчетов.Вставить("СчетаУчетаНоменклатураБезСклада", Результат[3].Выгрузить().ВыгрузитьКолонку("Счет"));
	
	Возврат СтруктураСчетов;
	
КонецФункции

#КонецОбласти

#КонецЕсли
