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
КонецПроцедуры

#КонецОбласти

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
	
	// Добавление дополнительных параметров
	БухгалтерскиеОтчетыКлиентСервер.ЗаполнитьДополнительныеПараметрыПечати(ДокументРезультат, ПараметрыОтчета);
КонецПроцедуры

Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
	
	ВыводитьЗаголовок = Ложь;
	ВыводитьПодписи = Ложь;
	Заголовок = "Среднесписочная численность сотрудников по графикам";
	
	Период  = Дата(1,1,1);
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ПараметрПериод <> Неопределено
		И ПараметрПериод.Использование
		И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
		
		Период = Дата(ПараметрПериод.Значение);
	КонецЕсли;
	
	ПараметрВыводитьЗаголовок = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	Если ПараметрВыводитьЗаголовок <> Неопределено
		И ПараметрВыводитьЗаголовок.Использование Тогда
		
		ВыводитьЗаголовок = ПараметрВыводитьЗаголовок.Значение;
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
	ПараметрыОтчета.Вставить("Период"            		, Период);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"        , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодписи"        	, ВыводитьПодписи);
	ПараметрыОтчета.Вставить("Заголовок"                , Заголовок);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"      , "СреднесписочнаяЧисленностьСотрудниковПоГрафикам");
	ПараметрыОтчета.Вставить("НастройкиОтчета"			, НастройкиОтчета);
		
	Возврат ПараметрыОтчета;
КонецФункции

#КонецЕсли