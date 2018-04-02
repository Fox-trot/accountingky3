﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ФункцииОтчетовКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	БухгалтерскиеОтчеты.ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки);
	Настройки.Печать.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
КонецПроцедуры

#КонецОбласти

// Процедура - обработчик события ПриКомпоновкеРезультата.
// Выполняет компоновку.
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(НастройкиОтчета);
	
	БухгалтерскиеОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	БухгалтерскиеОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	//Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	//Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	//Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	
	ТаблицаЗафиксирована = Ложь;
	ДокументРезультат.ФиксацияСверху = 0;
	
	//Основной цикл вывода отчета
	Пока Истина Цикл
		//Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			//Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;

			КонецЕсли;
			//Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, ДокументРезультат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, ДокументРезультат);
	
КонецПроцедуры

// Функция - Подготовить параметры отчета
//
// Параметры:
//  НастройкиОтчета	- НастройкиКомпоновкиДанных - пользовательские настройки
// 
// Возвращаемое значение:
//  Структура - Параметры отчета
//
Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
	
	ВыводитьПодписи = Ложь;
	Заголовок = "Журнал продаж";
	
	НачалоПериода = Дата(1,1,1);
	КонецПериода  = Дата(1,1,1);
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтПериод"));
	Если ПараметрПериод <> Неопределено И ПараметрПериод.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ Тогда
		Если ПараметрПериод.Использование
			И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
			
			НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
			КонецПериода  = ПараметрПериод.Значение.ДатаОкончания;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрВыводитьПодписи = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьПодписи"));
	Если ПараметрВыводитьПодписи <> Неопределено
		И ПараметрВыводитьПодписи.Использование Тогда
		ВыводитьПодписи = ПараметрВыводитьПодписи.Значение;
	КонецЕсли;
	
	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Заголовок = ПараметрВывода.Значение;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода"            , НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"             , КонецПериода);
	ПараметрыОтчета.Вставить("ВыводитьПодписи"        	, ВыводитьПодписи);
	ПараметрыОтчета.Вставить("Заголовок"                , Заголовок);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"      , "ЖурналПродаж");
	ПараметрыОтчета.Вставить("НастройкиОтчета"			, НастройкиОтчета);
		
	Возврат ПараметрыОтчета;
КонецФункции

#КонецЕсли