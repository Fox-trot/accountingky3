﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ДВИЖЕНИЯМИ ДОКУМЕНТОВ

Функция ПолучитьТаблицуПараметровПроведения(ИсходнаяТаблица, СписокКолонок) Экспорт

	Если ИсходнаяТаблица = Неопределено Тогда
		
		ТаблицаРезультат = Новый ТаблицаЗначений;
		Колонки = Новый Структура(СписокКолонок);
		Для каждого Колонка Из Колонки Цикл
			ТаблицаРезультат.Колонки.Добавить(Колонка.Ключ);
		КонецЦикла;
		Возврат ТаблицаРезультат;

	Иначе

		Возврат ИсходнаяТаблица.Скопировать(, СписокКолонок);

	КонецЕсли;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ДАННЫМИ В БАЗЕ

// Удаляет повторяющиеся элементы массива.
//
// Параметры:
//  ОбрабатываемыйМассив - Массив - элементы произвольных типов, из которых удаляются неуникальные.
//  НеИспользоватьНеопределено - Булево - если Истина, то все значения Неопределено удаляются из массива.
//  АнализироватьСсылкиКакИдентификаторы - Булево - если Истина, то для ссылок вызывается функция УникальныйИдентификатор()
//                                                  и уникальность определяется по строкам-идентификаторам.
//
// Возвращаемое значение:
//   Массив      - элементы ОбрабатываемыйМассив после удаления лишних.
//
Функция УдалитьПовторяющиесяЭлементыМассива(ОбрабатываемыйМассив, НеИспользоватьНеопределено = Ложь, АнализироватьСсылкиКакИдентификаторы = Ложь) Экспорт

	Если ТипЗнч(ОбрабатываемыйМассив) <> Тип("Массив") Тогда
		Возврат ОбрабатываемыйМассив;
	КонецЕсли;
	
	УжеВМассиве = Новый Соответствие;
	Если АнализироватьСсылкиКакИдентификаторы Тогда   // сравниваем ссылки как строки-уникальные идентификаторы
		
		ОписаниеСсылочныхТипов = ОбщегоНазначения.ОписаниеТипаВсеСсылки();
		
	 	БылоНеопределено = Ложь;
		КолвоЭлементовВМассиве = ОбрабатываемыйМассив.Количество();

		Для ОбратныйИндекс = 1 По КолвоЭлементовВМассиве Цикл
			
			ЭлементМассива = ОбрабатываемыйМассив[КолвоЭлементовВМассиве - ОбратныйИндекс];
			ТипЭлемента = ТипЗнч(ЭлементМассива);
			Если ЭлементМассива = Неопределено Тогда
				Если БылоНеопределено или НеИспользоватьНеопределено Тогда
					ОбрабатываемыйМассив.Удалить(КолвоЭлементовВМассиве - ОбратныйИндекс);
				Иначе
					БылоНеопределено = Истина;
				КонецЕсли;
				Продолжить;
			ИначеЕсли ОписаниеСсылочныхТипов.СодержитТип(ТипЭлемента) Тогда

				ИДЭлемента = Строка(ЭлементМассива.УникальныйИдентификатор());

			Иначе

				ИДЭлемента = ЭлементМассива;

			КонецЕсли;

			Если УжеВМассиве[ИДЭлемента] = Истина Тогда
				ОбрабатываемыйМассив.Удалить(КолвоЭлементовВМассиве - ОбратныйИндекс);
			Иначе
				УжеВМассиве[ИДЭлемента] = Истина;
			КонецЕсли;
			
		КонецЦикла;

	Иначе
		
		ИндексЭлемента = 0;
		КоличествоЭлементов = ОбрабатываемыйМассив.Количество();
		Пока ИндексЭлемента < КоличествоЭлементов Цикл
			
			ЭлементМассива = ОбрабатываемыйМассив[ИндексЭлемента];
			Если НеИспользоватьНеопределено И ЭлементМассива = Неопределено
			 Или УжеВМассиве[ЭлементМассива] = Истина Тогда      // удаляем, переходя к следующему
			 
				ОбрабатываемыйМассив.Удалить(ИндексЭлемента);
				КоличествоЭлементов = КоличествоЭлементов - 1;
				
			Иначе   // запоминаем, переходя к следующему
				
				УжеВМассиве.Вставить(ЭлементМассива, Истина);
				ИндексЭлемента = ИндексЭлемента + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

	Возврат ОбрабатываемыйМассив;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ТАБЛИЦАМИ

// Добавляет в таблицу значений строки из другой таблицы значений и
// в них значения колонок с совпадающими наименованиями.
//
// Параметры:
//  ТаблицаИсточник - таблица значений, откуда берутся значения.
//  ТаблицаПриемник - таблица значений, куда добавляются строки.
//
Процедура ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, ТаблицаПриемник) Экспорт

	Для каждого СтрокаТаблицыИсточника Из ТаблицаИсточник Цикл

		СтрокаТаблицыПриемника = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтрокаТаблицыИсточника);

	КонецЦикла;

КонецПроцедуры // ЗагрузитьВТаблицуЗначений()

Процедура УпорядочитьТаблицуПоДокументу(ТаблицаЗначений, КолонкаДокумента, КолонкаДаты, Направление = "Возр") Экспорт

	Если ТаблицаЗначений.Колонки.Найти(КолонкаДаты) = Неопределено Тогда
		ТаблицаЗначений.Колонки.Добавить(КолонкаДаты, ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
	КонецЕсли;
	
	Если ТаблицаЗначений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьДатуДокументаКРезультатуЗапроса(ТаблицаЗначений, КолонкаДокумента, КолонкаДаты);
	
	СписокКолонок = КолонкаДаты + " " + Направление + ", " + КолонкаДокумента + " " + Направление;
	ТаблицаЗначений.Сортировать(СписокКолонок, Новый СравнениеЗначений);
	
КонецПроцедуры

Процедура ДобавитьДатуДокументаКРезультатуЗапроса(Результат, КолонкаДокумента, КолонкаСДатой) Экспорт

	КэшПоТипам = Новый Соответствие;
	
	Для каждого СтрокаТаблицы из Результат Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы[КолонкаДокумента]) тогда
			Продолжить;
		КонецЕсли;
		
		ТипТекущегоДокумента = ТипЗнч(СтрокаТаблицы[КолонкаДокумента]);
		МассивТипа = КэшПоТипам[ТипТекущегоДокумента];
		Если МассивТипа = Неопределено Тогда
			МассивТипа = Новый Массив;
			КэшПоТипам.Вставить(ТипТекущегоДокумента, МассивТипа);
		КонецЕсли;
		МассивТипа.Добавить(СтрокаТаблицы[КолонкаДокумента]);
	КонецЦикла;
	
	Если КэшПоТипам.Количество()=0 тогда
		Возврат;
	КонецЕсли;
	
	Запрос = новый запрос;
	
	Для Каждого КлючИЗначение ИЗ КэшПоТипам Цикл
		ИмяМетаданных = Метаданные.НайтиПоТипу(КлючИЗначение.Ключ).Имя;
		
		Запрос.Текст = Запрос.Текст + ?(Запрос.Текст = "",
			"",
			"
			|Объединить Все
			|");
			
		Запрос.Текст = Запрос.Текст +
		"ВЫБРАТЬ
		|	Док.Ссылка КАК Ссылка,
		|	Док.Дата
		|ИЗ
		|	Документ."+ИмяМетаданных+" КАК Док
		|ГДЕ
		|	Док.Ссылка В(&ДокументыТипа_"+ИмяМетаданных+")";
		
		УдалитьПовторяющиесяЭлементыМассива(КлючИЗначение.Значение);
		Запрос.УстановитьПараметр("ДокументыТипа_"+ИмяМетаданных, КлючИЗначение.Значение);
		
	КонецЦикла;
	
	Результат.Индексы.Добавить(КолонкаДокумента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить(КолонкаДокумента, Выборка.Ссылка);
		
		НайденныеСтроки = Результат.НайтиСтроки(ПараметрыОтбора);
		Для Каждого строка ИЗ НайденныеСтроки Цикл
			строка[КолонкаСДатой] = Выборка.Дата;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // ДобавитьДатуДокументаКРезультатуЗапроса()

Процедура ПронумероватьТаблицу(ТаблицаЗначений, ИмяКолонкиНомера = "НомерСтроки") Экспорт

	Если ТаблицаЗначений.Колонки.Найти(ИмяКолонкиНомера) = Неопределено Тогда
		ТаблицаЗначений.Колонки.Добавить(ИмяКолонкиНомера, Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0)));
	КонецЕсли;

	Ном = 1;
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		СтрокаТаблицы[ИмяКолонкиНомера] = Ном;
		Ном = Ном + 1;
	КонецЦикла;

КонецПроцедуры

Функция ПустаяТаблицаРегистраНакопления(ИмяРегистра) Экспорт

	ПустаяТаблица = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей().ВыгрузитьКолонки();
	ПустаяТаблица.Колонки.Удалить("Регистратор");
	ПустаяТаблица.Колонки.Удалить("МоментВремени");
	ПустаяТаблица.Колонки.Удалить("Активность");
	Если ПустаяТаблица.Колонки.Найти("ВидДвижения") <> Неопределено Тогда
		ПустаяТаблица.Колонки.Удалить("ВидДвижения");
	КонецЕсли;

	Возврат ПустаяТаблица;

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОЛУЧЕНИЯ И УСТАНОВКИ НАСТРОЕК ПОЛЬЗОВАТЕЛЕЙ

// Процедура записывает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Настройка    - Строка - вид настройки
//  Значение     - значение настройки
//  ИмяПользователяИБ - Строка - имя пользователя программы, для которого устанавливается настройка
//
// Возвращаемое значение:
//  Нет
//
Процедура УстановитьЗначениеПоУмолчанию(Настройка, Значение, ИмяПользователяИБ = Неопределено) Экспорт

	Если ВРег(Настройка) = ВРег("ОсновнаяОрганизация")
		ИЛИ ВРег(Настройка) = ВРег("ВариантРабочегоСтола") Тогда
		
		ХранилищеОбщихНастроек.Сохранить(ВРег(Настройка),, Значение,, ИмяПользователяИБ);
		
	ИначеЕсли ВРег(Настройка) = ВРег("РабочаяДата") Тогда
		ОбщегоНазначения.УстановитьРабочуюДатуПользователя(Значение, ИмяПользователяИБ);
	ИначеЕсли ВРег(Настройка) = ВРег("ПоказыватьСчетаУчетаВДокументах")
		ИЛИ ВРег(Настройка) = Врег("УчетнаяЗаписьЭлектроннойПочты")
		ИЛИ ВРег(Настройка) = Врег("Подпись")
		ИЛИ ВРег(Настройка) = ВРег("ВидЭДРеализации") Тогда
		
		ХранилищеОбщихНастроек.Сохранить(ВРег(Настройка),, Значение,, ИмяПользователяИБ);
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьЗначениеПоУмолчанию()

Функция ПолучитьЗначениеПоУмолчанию(Настройка, ИмяПользователяИБ = Неопределено) Экспорт
	
	Возврат БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию(Настройка, ИмяПользователяИБ);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ДИНАМИЧЕСКИМИ СПИСКАМИ

// Возвращает отборы динамического списка как значения заполнения при программном вводе новой строки в список
//
// Параметры:
//  КомпоновщикНастроек  - КомпоновщикНастроекДинамическогоСписка - компоновщик настроек списка
//
// Возвращаемое значение:
//   Структура   - значения отборов для заполнения нового элемента списка
//
Функция ЗначенияЗаполненияДинамическогоСписка(Знач КомпоновщикНастроек) Экспорт
	
	ЗначенияЗаполнения = Новый Структура;
	
	НастройкиСписка = КомпоновщикНастроек.ПолучитьНастройки();
	ДобавитьЗначенияЗаполнения(НастройкиСписка.Отбор.Элементы, ЗначенияЗаполнения);
	
	Возврат ЗначенияЗаполнения;

КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ

Процедура ЗаполнитьСписокОрганизаций(ЭлементПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СоответствиеОрганизаций = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	Организации.Наименование КАК ОрганизацияПредставление
	|ИЗ
	|	Справочник.Организации КАК Организации
	|УПОРЯДОЧИТЬ ПО
	|	ОрганизацияПредставление";
	
	Выборка = Запрос.Выполнить().Выбрать();
	                                                                        
	ЭлементПолеОрганизация.СписокВыбора.Очистить();                                      
	МаксКоличествоСимволов = 40;
	Пока Выборка.Следующий() Цикл
		Ключ     = СтрЗаменить("_" + Выборка.Организация.УникальныйИдентификатор(), "-", "");
		Значение = Новый Структура("Организация", Выборка.Организация);
		СоответствиеОрганизаций.Вставить(Ключ, Значение);
		
		ОрганизацияПредставление = Выборка.ОрганизацияПредставление;
		
		ЭлементПолеОрганизация.СписокВыбора.Добавить(Ключ, ОрганизацияПредставление);
		
		МаксКоличествоСимволов = Макс(МаксКоличествоСимволов, СтрДлина(ОрганизацияПредставление));
	КонецЦикла;
	
	ЭлементПолеОрганизация.ШиринаСпискаВыбора = Окр(?(МаксКоличествоСимволов > 200, 200, МаксКоличествоСимволов) * 1.3);
	ЭлементПолеОрганизация.ВысотаСпискаВыбора = ?(ЭлементПолеОрганизация.СписокВыбора.Количество() > 15, 15, ЭлементПолеОрганизация.СписокВыбора.Количество());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

// Проверяет, умещаются ли переданные табличные документы на страницу при печати.
//
// Параметры
//  ТабДокумент       – Табличный документ
//  ВыводимыеОбласти  – Массив из проверяемых таблиц или табличный документ
//  РезультатПриОшибке - Какой возвращать результат при возникновении ошибки
//
// Возвращаемое значение:
//   Булево   – умещаются или нет переданные документы
//
Функция ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, РезультатПриОшибке = Истина) Экспорт

	Попытка
		Возврат ТабДокумент.ПроверитьВывод(ВыводимыеОбласти);
	Исключение
		ШаблонСообщения = НСТр("ru = 'Невозможно получить информацию о текущем принтере (возможно, в системе не установлено ни одного принтера)
                                |%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Проверка вывода на печать'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		Возврат РезультатПриОшибке;
	КонецПопытки;

КонецФункции // ПроверитьВыводТабличногоДокумента()

Функция ТекстРазделителяЗапросовПакета() Экспорт

	ТекстРазделителя =
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстРазделителя;

КонецФункции

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьЗначенияЗаполнения(КоллекцияОтборов, ЗначенияЗаполнения)

	Для каждого ЭлементОтбора Из КоллекцияОтборов Цикл
	
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") 
			И ЭлементОтбора.Использование 
			И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			
			НаименованиеОтбора = Строка(ЭлементОтбора.ЛевоеЗначение);
			Если СтрНайти(НаименованиеОтбора, ".") = 0 Тогда
				ЗначенияЗаполнения.Вставить(НаименованиеОтбора, ЭлементОтбора.ПравоеЗначение);
			КонецЕсли;
		ИначеЕсли ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") 
			И ЭлементОтбора.Использование 
			И ЭлементОтбора.ТипГруппы <> ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
			
			ДобавитьЗначенияЗаполнения(ЭлементОтбора.Элементы, ЗначенияЗаполнения);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьТекстВопросаПриУдаленииСубконто(Знач СтруктураПараметровУчета) Экспорт
	
	ДополнительныеПараметры = ОбщегоНазначенияБПСервер.ПолучитьСтруктуруДополнительныхПараметров();
	ДополнительныеПараметры.УчетТМЗ = Истина;
	ДействияИзмененияСубконто = ОбщегоНазначенияБПСервер.ПолучитьДействияИзмененияСубконто(СтруктураПараметровУчета, ДополнительныеПараметры);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДействий", ДействияИзмененияСубконто);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.Счет КАК Счет,
		|	ВЫРАЗИТЬ(Таблица.Субконто КАК ПланВидовХарактеристик.ВидыСубконтоХозрасчетные) КАК Субконто,
		|	-Таблица.Действие КАК Действие,
		|	-Таблица.Количественный КАК Количественный,
		|	-Таблица.Суммовой КАК Суммовой,
		|	Таблица.ТолькоОбороты КАК ТолькоОбороты,
		|	-Таблица.Валютный КАК Валютный
		|ПОМЕСТИТЬ СчетаСубконто
		|ИЗ
		|	&ТаблицаДействий КАК Таблица
		|ГДЕ
		|	(Таблица.Действие = -1
		|			ИЛИ Таблица.Количественный = -1
		|			ИЛИ Таблица.Суммовой = -1
		|			ИЛИ Таблица.ТолькоОбороты = 1
		|			ИЛИ Таблица.Валютный = -1)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетаСубконто.Субконто.Наименование КАК Субконто,
		|	МАКСИМУМ(СчетаСубконто.Действие) КАК Действие,
		|	МАКСИМУМ(СчетаСубконто.Количественный) КАК Количественный,
		|	МАКСИМУМ(СчетаСубконто.Суммовой) КАК Суммовой,
		|	МАКСИМУМ(СчетаСубконто.ТолькоОбороты) КАК ТолькоОбороты,
		|	МАКСИМУМ(СчетаСубконто.Валютный) КАК Валютный
		|ИЗ
		|	СчетаСубконто КАК СчетаСубконто
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетаСубконто.Субконто.Наименование
		|
		|УПОРЯДОЧИТЬ ПО
		|	Субконто";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	ТаблицаДействий = РезультатЗапроса.Выгрузить();
	
	ВидыДействий = Новый Структура;
	ВидыДействий.Вставить("Действие", НСтр("ru = 'Будут удалены следующие субконто: %1'"));
	ВидыДействий.Вставить("Количественный", НСтр("ru = 'Будут очищены количественные обороты по следующим субконто: %1'"));
	ВидыДействий.Вставить("Суммовой", НСтр("ru = 'Будут очищены суммовые обороты по следующим субконто: %1'"));
	ВидыДействий.Вставить("ТолькоОбороты", НСтр("ru = 'Будут очищены остатки по следующим субконто: %1'"));
	ВидыДействий.Вставить("Валютный", НСтр("ru = 'Будут очищены валютные обороты по следующим субконто: %1'"));
	
	ТекстВопроса = "";
	Для каждого ВидДействия Из ВидыДействий Цикл
		ИзменениеПризнакаСубконто = ВидДействия.Ключ <> "Действие";
		
		СписокСубконто = "";
		СтрокиСубконто = ТаблицаДействий.НайтиСтроки(Новый Структура(ВидДействия.Ключ, 1));
		Для каждого СтрокаСубконто Из СтрокиСубконто Цикл
			Если ИзменениеПризнакаСубконто И СтрокаСубконто.Действие <> 0 Тогда
				// При добавлении / удалении субконто других сообщений выводить не нужно
				Продолжить;
			КонецЕсли;
			
			СписокСубконто = СписокСубконто + ", " + СтрокаСубконто.Субконто;
		КонецЦикла;
		
		Если ПустаяСтрока(СписокСубконто) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ТекстВопроса) Тогда
			ТекстВопроса = ТекстВопроса + Символы.ПС;
		КонецЕсли;
		
		ТекстДействия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ВидДействия.Значение,
			Сред(СписокСубконто, 3));
		ТекстВопроса = ТекстВопроса + ТекстДействия;
	КонецЦикла;
	
	Если ПустаяСтрока(ТекстВопроса) Тогда
		Возврат "";
	КонецЕсли;
	
	ШаблонТекста = НСтр("ru = '%1
		|Продолжить?'");
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, ТекстВопроса);
	
	Возврат ТекстВопроса;
	
КонецФункции

#КонецОбласти