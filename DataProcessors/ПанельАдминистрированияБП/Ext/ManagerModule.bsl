﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура отвечает за включение учета основных средств по подразделениям
//
Процедура ВключитьУчетДвиженияОСПоПодразделениям() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыУчета = БухгалтерскийУчетСервер.ОпределитьПараметрыУчета();
	Если НЕ ПараметрыУчета.ВестиУчетОСПоПодразделениям Тогда
		ПараметрыУчета.ВестиУчетОСПоПодразделениям = Истина;
		ПрименитьПараметрыУчета(ПараметрыУчета);
	КонецЕсли;
	
КонецПроцедуры

// Процедура отвечает за включение учета основных средств по МОЛ
Процедура ВключитьУчетДвиженияОСПоМОЛ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыУчета = БухгалтерскийУчетСервер.ОпределитьПараметрыУчета();
	Если НЕ ПараметрыУчета.ВестиУчетОСПоМОЛ Тогда
		ПараметрыУчета.ВестиУчетОСПоМОЛ = Истина;
		ПрименитьПараметрыУчета(ПараметрыУчета);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрименитьПараметрыУчета(ПараметрыУчета, ИзмененыПараметрыСубконто = Ложь, Отказ = Ложь) Экспорт
	
	ПризнакиУчета = ПолучитьСтруктуруПризнаковУчетаСубконто();
	ДействияИзмененияСубконто = ПолучитьДействияИзмененияСубконто(ПараметрыУчета); // Иерархическая коллекция: на первом уровне действия с субконто на каждом из счетов, на втором - действия с призаками учета.
	
	// Сгруппируем изменения по счетам, так как записывать будем именно счет
	СчетаКИзменению = ОбщегоНазначения.ВыгрузитьКолонку(ДействияИзмененияСубконто, "Счет", Истина);
	ДействияИзмененияСубконто.Индексы.Добавить("Счет");
	СтруктураОтбора = Новый Структура("Счет");
	
	НачатьТранзакцию();

	Для Каждого Счет Из СчетаКИзменению Цикл
		
		СтруктураОтбора.Счет = Счет;
		ДействияДляСчета = ДействияИзмененияСубконто.НайтиСтроки(СтруктураОтбора);
		
		Объект = Счет.ПолучитьОбъект();
		
		ПротоколИзменений = Новый Массив;
		
		Для Каждого Действие Из ДействияДляСчета Цикл
			
			// Действие: -1 удалить; 0 - не менять; 1 - установить
			
			// Действия с видом субконто
			Если Действие.Действие = 1 Тогда
				
				// Добавить субконто
				ВидыСубконтоСтрока = Объект.ВидыСубконто.Добавить();
				ВидыСубконтоСтрока.ВидСубконто = Действие.Субконто;
				
				ДобавитьВПротоколИзменениеСубконто(ПротоколИзменений, ВидыСубконтоСтрока.ВидСубконто, Действие.Действие);
				
			Иначе
				
				ВидыСубконтоСтрока = Объект.ВидыСубконто.Найти(Действие.Субконто, "ВидСубконто");
				Если ВидыСубконтоСтрока = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			Если Действие.Действие = -1 Тогда
				
				ДобавитьВПротоколИзменениеСубконто(ПротоколИзменений, ВидыСубконтоСтрока.ВидСубконто, Действие.Действие);
				
				Объект.ВидыСубконто.Удалить(ВидыСубконтоСтрока);
				
				Продолжить;
				
			КонецЕсли;
			
			// Действия с признаками учета
			
			Для Каждого ПризнакУчета Из ПризнакиУчета Цикл
				
				ДействиеСПризнаком = Действие[ПризнакУчета.Ключ];

				Если ДействиеСПризнаком = 1 Тогда
					ЗначениеПризнака = Истина;
				ИначеЕсли ДействиеСПризнаком = -1 Тогда
					ЗначениеПризнака = Ложь;
				Иначе
					Продолжить;
				КонецЕсли;
				
				Если ВидыСубконтоСтрока[ПризнакУчета.Ключ] = ЗначениеПризнака Тогда
					Продолжить;
				КонецЕсли;
				
				ВидыСубконтоСтрока[ПризнакУчета.Ключ] = ЗначениеПризнака;
				
				ДобавитьВПротоколИзменениеПризнакаУчета(
					ПротоколИзменений, 
					ВидыСубконтоСтрока.ВидСубконто, 
					ПризнакУчета.Значение, 
					ДействиеСПризнаком);
				
			КонецЦикла; // По признакам учета
			
		КонецЦикла; // По ДействияДляСчета
		
		Если Не Объект.Модифицированность() Тогда
			Продолжить;
		КонецЕсли;
		
		ПротоколИзмененийСтрокой = СтрСоединить(ПротоколИзменений, Символы.ПС);
		
		Попытка
			Объект.Записать();
		Исключение
			ОписаниеОшибки = ИнформацияОбОшибке();
			ОтменитьТранзакцию();
			
			Отказ = Истина;
			
			ШаблонТекста = НСтр("ru = 'Ошибка при записи счета [КодСчета]:
				|[ОписаниеОшибки]
				|Ошибка произошла при попытке выполнить следующие изменения:
				|[ПротоколИзменений]'");
				
			ПараметрыТекста = Новый Структура;
			ПараметрыТекста.Вставить("КодСчета",          Объект.Код);
			ПараметрыТекста.Вставить("ПротоколИзменений", ПротоколИзмененийСтрокой);
			
			// В журнал регистрации выведем подробную информацию
			ПараметрыТекста.Вставить("ОписаниеОшибки", ПодробноеПредставлениеОшибки(ОписаниеОшибки));
			
			Текст = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонТекста, ПараметрыТекста);
			ЗаписьЖурналаРегистрации(
				СобытиеЖурналаРегистрацииПараметрыУчета(),
				УровеньЖурналаРегистрации.Ошибка,
				Счет.Метаданные(),
				Счет, // Данные
				Текст);
				
			// Пользователю выведем краткое сообщение
			ШаблонТекста = НСтр("ru = 'Ошибка при записи счета [КодСчета]
				|Подробности см. в Журнале регистрации.'");
			Текст = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонТекста, ПараметрыТекста);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
			
			Возврат;
			
		КонецПопытки;
		
		// Запишем в журнал регистрации подробную информацию об изменениях
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрацииПараметрыУчета(),
			УровеньЖурналаРегистрации.Информация, 
			Счет.Метаданные(),
			Счет,
			ПротоколИзмененийСтрокой,
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		
	КонецЦикла; // По СчетаКИзменению

	ЗафиксироватьТранзакцию();
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПризнаковУчетаСубконто()

	ПризнакиУчета = Новый Структура;
	ПризнакиУчета.Вставить("Количественный", НСтр("ru = 'Количественный'"));
	ПризнакиУчета.Вставить("Суммовой", НСтр("ru = 'Суммовой'"));
	ПризнакиУчета.Вставить("ТолькоОбороты", НСтр("ru = 'Только обороты'"));
	ПризнакиУчета.Вставить("Валютный", НСтр("ru = 'Валютный'"));

	Возврат ПризнакиУчета;

КонецФункции

Функция ПолучитьДействияИзмененияСубконто(ПараметрыУчетаФормы)

	ПараметрыУчета = Новый Структура;
	Для каждого КлючИЗначение Из ПараметрыУчетаФормы Цикл
		ПараметрыУчета.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ПараметрыСубконто = ПолучитьСоответствиеСубконтоПараметрамУчета();

	ПризнакиУчета = ПолучитьСтруктуруПризнаковУчетаСубконто();

	ТипДействия = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Любой));
	// -1 удалить; 0 - не менять; 1 - установить

	ТаблицаДействий = Новый ТаблицаЗначений;
	ТаблицаДействий.Колонки.Добавить("Счет", Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	ТаблицаДействий.Колонки.Добавить("Субконто", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные"));
	ТаблицаДействий.Колонки.Добавить("Действие", ТипДействия);
	Для каждого ПризнакУчета Из ПризнакиУчета Цикл
		ТаблицаДействий.Колонки.Добавить(ПризнакУчета.Ключ, ТипДействия);
	КонецЦикла;

	Для каждого ОписаниеГруппыСчетов Из ПараметрыСубконто Цикл

		СчетаВСписке = Новый Массив;
		СчетаВИерархии = Новый Массив;
		СчетаНеВИерархии = ОписаниеГруппыСчетов.ИсключенияИерархии;

		Для каждого ОписаниеСчета Из ОписаниеГруппыСчетов.Счета Цикл
			Если ОписаниеСчета.СПодчиненными Тогда
				СчетаВИерархии.Добавить(ОписаниеСчета.Счет);
			Иначе
				СчетаВСписке.Добавить(ОписаниеСчета.Счет);
			КонецЕсли;
		КонецЦикла;

		// Получим список счетов для обработки
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СчетаВСписке", СчетаВСписке);
		Запрос.УстановитьПараметр("СчетаВИерархии", СчетаВИерархии);
		Запрос.УстановитьПараметр("СчетаНеВИерархии", СчетаНеВИерархии);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Счет,
		|	Хозрасчетный.Порядок КАК Порядок,
		|	Хозрасчетный.Код,
		|	Хозрасчетный.Валютный,
		|	Хозрасчетный.Количественный,
		|	Хозрасчетный.ВидыСубконто.(
		|		НомерСтроки КАК НомерСтроки,
		|		ВидСубконто,
		|		ТолькоОбороты,
		|		Суммовой,
		|		Валютный,
		|		Количественный
		|	)
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	(Хозрасчетный.Ссылка В (&СчетаВСписке)
		|			ИЛИ Хозрасчетный.Ссылка В ИЕРАРХИИ (&СчетаВИерархии)
		|				И (НЕ Хозрасчетный.Ссылка В ИЕРАРХИИ (&СчетаНеВИерархии)))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок,
		|	Счет,
		|	НомерСтроки";

		ВыборкаСчетов = Запрос.Выполнить().Выбрать();
		Пока ВыборкаСчетов.Следующий() Цикл

			ПараметрыСчета = ПолучитьЗначенияПараметровУчетаДляСчета(ПараметрыУчета,
				ОписаниеГруппыСчетов.Параметры, ВыборкаСчетов.Счет);

			ВидыСубконто = ВыборкаСчетов.ВидыСубконто.Выгрузить();

			Для каждого ОписаниеСубконто Из ОписаниеГруппыСчетов.Субконто Цикл
				СтрокаДействия = Неопределено;

				ИспользованиеСубконто = ПолучитьЗначениеПараметраУчетаСубконто(ОписаниеСубконто.Параметр,
					ПараметрыСчета, ВыборкаСчетов);

				Если ИспользованиеСубконто = Неопределено Тогда
					Продолжить;
				КонецЕсли;

				СтрокаСубконто = ВидыСубконто.Найти(ОписаниеСубконто.Вид, "ВидСубконто");
				Если ИспользованиеСубконто Тогда
					Если СтрокаСубконто = Неопределено Тогда
						СтрокаДействия = ТаблицаДействий.Добавить();
						СтрокаДействия.Счет = ВыборкаСчетов.Счет;
						СтрокаДействия.Субконто = ОписаниеСубконто.Вид;
						СтрокаДействия.Действие = 1;						
					КонецЕсли;

					// проверим признаки учета
					Для каждого ПризнакУчета Из ПризнакиУчета Цикл
						ЗначениеПризнака = ПолучитьЗначениеПараметраУчетаСубконто(ОписаниеСубконто[ПризнакУчета.Ключ],
							ПараметрыСчета, ВыборкаСчетов);
						Если ЗначениеПризнака = Неопределено Тогда
							Продолжить;
						КонецЕсли;

						Если СтрокаСубконто = Неопределено
							ИЛИ СтрокаСубконто[ПризнакУчета.Ключ] <> ЗначениеПризнака Тогда

							Если СтрокаДействия = Неопределено Тогда
								СтрокаДействия = ТаблицаДействий.Добавить();
								СтрокаДействия.Счет = ВыборкаСчетов.Счет;
								СтрокаДействия.Субконто = ОписаниеСубконто.Вид;
							КонецЕсли;
							Если ЗначениеПризнака Тогда
								СтрокаДействия[ПризнакУчета.Ключ] = 1;
							Иначе
								СтрокаДействия[ПризнакУчета.Ключ] = -1;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
				Иначе
					Если СтрокаСубконто = Неопределено Тогда
						Продолжить;
					Иначе
						СтрокаДействия = ТаблицаДействий.Добавить();
						СтрокаДействия.Счет = ВыборкаСчетов.Счет;
						СтрокаДействия.Субконто = ОписаниеСубконто.Вид;
						СтрокаДействия.Действие = -1;
					КонецЕсли;
				КонецЕсли;

			КонецЦикла;

		КонецЦикла;
	КонецЦикла;

	Возврат ТаблицаДействий;

КонецФункции

Функция ПолучитьСоответствиеСубконтоПараметрамУчета()

	// Структура параметров
	Результат = Новый ТаблицаЗначений; // Структуры СтруктураПараметров
	Результат.Колонки.Добавить("Счета"); // Счета для обработки, таблица значений со структурой КолонкиСчетов
	Результат.Колонки.Добавить("ИсключенияИерархии", Новый ОписаниеТипов("Массив")); // Массив счетов
		// которые не должны обрабатываться при обработке подчиненных счетов
	Результат.Колонки.Добавить("Субконто"); // Параметры субконто, таблица значений со структурой КолонкиСубконто
	Результат.Колонки.Добавить("Параметры", Новый ОписаниеТипов("ТаблицаЗначений")); // Список параметров и
		// значения исключений, таблица значений со структурой КолонкиПараметров
	КолонкиСчетов = Новый ТаблицаЗначений;
	КолонкиСчетов.Колонки.Добавить("Счет", Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	КолонкиСчетов.Колонки.Добавить("СПодчиненными", Новый ОписаниеТипов("Булево")); // Обрабатывать все субсчета

	// Имя параметра, константа типа Булево или строка "ПоСчету" (только для признаков учета Количественный и Валютный)
	// Неопределено - не менять
	ТипПараметра = Новый ОписаниеТипов("Неопределено, Строка, Булево", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная));

	КолонкиСубконто = Новый ТаблицаЗначений;
	КолонкиСубконто.Колонки.Добавить("Вид", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные"));
	КолонкиСубконто.Колонки.Добавить("Параметр", ТипПараметра); // Необходимость включения субконто
	КолонкиСубконто.Колонки.Добавить("Количественный", ТипПараметра);
	КолонкиСубконто.Колонки.Добавить("Суммовой", ТипПараметра);
	КолонкиСубконто.Колонки.Добавить("ТолькоОбороты", ТипПараметра);
	КолонкиСубконто.Колонки.Добавить("Валютный", ТипПараметра);

	КолонкиПараметров = Новый ТаблицаЗначений; // Описания параметров учета
	// Имя параметра учета
	КолонкиПараметров.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	КолонкиПараметров.Колонки.Добавить("Исключения", Новый ОписаниеТипов("ТаблицаЗначений")); // Счета, для которых будут
		//использоваться константные значения вместо значений параметров
	КолонкиИсключений = Новый ТаблицаЗначений;
	КолонкиИсключений.Колонки.Добавить("Счет", Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	КолонкиИсключений.Колонки.Добавить("СПодчиненными", Новый ОписаниеТипов("Булево"));
	КолонкиИсключений.Колонки.Добавить("Значение", Новый ОписаниеТипов("Неопределено, Булево"));

	////////////////////////////////////////////////////////////////
	// Учет ОС
	СтрокаРезультата = Результат.Добавить();

	// Счета
	Счета = КолонкиСчетов.СкопироватьКолонки();
	СтрокаРезультата.Счета = Счета;

	СчетаУчетаОсновныхСредств = БухгалтерскийУчетВызовСервераПовтИсп.СчетаУчетаОсновныхСредствИНематериальныхАктивов();
	Для Каждого СчетУчета Из СчетаУчетаОсновныхСредств Цикл 
		СтрокаСчета = Счета.Добавить();
		СтрокаСчета.Счет = СчетУчета;
		СтрокаСчета.СПодчиненными = Истина;
	КонецЦикла;	

	// Исключения иерархии
	ИсключенияИерархии = Новый Массив;
	СтрокаРезультата.ИсключенияИерархии = ИсключенияИерархии;
	
	ИсключенияИерархии.Добавить(ПланыСчетов.Хозрасчетный.МодернизацияОС);
	ИсключенияИерархии.Добавить(ПланыСчетов.Хозрасчетный.МодернизацияНМА);
	
	// Субконто
	Субконто = КолонкиСубконто.СкопироватьКолонки();
	СтрокаРезультата.Субконто = Субконто;

	СтрокаСубконто = Субконто.Добавить();
	СтрокаСубконто.Вид = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства;
	СтрокаСубконто.Параметр = Истина;
	СтрокаСубконто.Количественный = Ложь;
	СтрокаСубконто.Суммовой = Истина;
	СтрокаСубконто.ТолькоОбороты = Ложь;
	СтрокаСубконто.Валютный = Ложь;

	СтрокаСубконто = Субконто.Добавить();
	СтрокаСубконто.Вид = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Подразделения;
	СтрокаСубконто.Параметр = "ВестиУчетОСПоПодразделениям";
	СтрокаСубконто.Количественный = Ложь;
	СтрокаСубконто.Суммовой = Истина;
	СтрокаСубконто.ТолькоОбороты = Ложь;
	СтрокаСубконто.Валютный = Ложь;

	СтрокаСубконто = Субконто.Добавить();
	СтрокаСубконто.Вид = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций;
	СтрокаСубконто.Параметр = "ВестиУчетОСПоМОЛ";
	СтрокаСубконто.Количественный = Ложь;
	СтрокаСубконто.Суммовой = Истина;
	СтрокаСубконто.ТолькоОбороты = Ложь;
	СтрокаСубконто.Валютный = Ложь;

	// Параметры
	Параметры = КолонкиПараметров.СкопироватьКолонки();
	СтрокаРезультата.Параметры = Параметры;

	СтрокаПараметра = Параметры.Добавить();
	СтрокаПараметра.Имя = "ВестиУчетОСПоПодразделениям";
	СтрокаПараметра.Исключения = КолонкиИсключений.Скопировать();

	СтрокаПараметра = Параметры.Добавить();
	СтрокаПараметра.Имя = "ВестиУчетОСПоМОЛ";
	СтрокаПараметра.Исключения = КолонкиИсключений.Скопировать();

	// Исключения
	СтрокаИсключения = СтрокаПараметра.Исключения.Добавить();
	СтрокаИсключения.Счет = ПланыСчетов.Хозрасчетный.КапитальныйРемонтОС;
	СтрокаИсключения.СПодчиненными = Истина;
	СтрокаИсключения.Значение = Неопределено;
	
	СтрокаИсключения = СтрокаПараметра.Исключения.Добавить();
	СтрокаИсключения.Счет = ПланыСчетов.Хозрасчетный.МодернизацияНМА;
	СтрокаИсключения.СПодчиненными = Истина;
	СтрокаИсключения.Значение = Неопределено;
	
	СтрокаИсключения = СтрокаПараметра.Исключения.Добавить();
	СтрокаИсключения.Счет = ПланыСчетов.Хозрасчетный.МодернизацияОС;
	СтрокаИсключения.СПодчиненными = Истина;
	СтрокаИсключения.Значение = Неопределено;
	
	Возврат Результат;

КонецФункции

Функция ПолучитьЗначенияПараметровУчетаДляСчета(ПараметрыУчета, ПараметрыГруппыСчетов, Счет)

	Результат = Новый Структура;

	Для каждого СтрокаПараметра Из ПараметрыГруппыСчетов Цикл
		ЗначениеУстановлено = Ложь;
		Для каждого СтрокаИсключения Из СтрокаПараметра.Исключения Цикл
			Если СтрокаИсключения.Счет = Счет Тогда
				ЗначениеПараметра = СтрокаИсключения.Значение;
				ЗначениеУстановлено = Истина;
				Прервать;
			Иначе
				Если СтрокаИсключения.СПодчиненными
					И БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(Счет, СтрокаИсключения.Счет) Тогда

					ЗначениеПараметра = СтрокаИсключения.Значение;
					ЗначениеУстановлено = Истина;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

		Если НЕ ЗначениеУстановлено Тогда
			ЗначениеПараметра = ПараметрыУчета[СтрокаПараметра.Имя];
		КонецЕсли;
		Результат.Вставить(СтрокаПараметра.Имя, ЗначениеПараметра);
	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ПолучитьЗначениеПараметраУчетаСубконто(Параметр, ЗначенияПараметровУчетаДляСчета, СтрокаСчета)

	Если Параметр = Неопределено ИЛИ ТипЗнч(Параметр) = Тип("Булево") Тогда
		Возврат Параметр;
	Иначе
		Если ЗначенияПараметровУчетаДляСчета.Свойство(Параметр) Тогда
			Возврат ЗначенияПараметровУчетаДляСчета[Параметр];
		Иначе
			Возврат СтрокаСчета[Параметр];
		КонецЕсли;
	КонецЕсли;

КонецФункции

Процедура ДобавитьВПротоколИзменениеСубконто(ПротоколИзменений, ВидСубконто, Изменение)
	
	Если Изменение = 1 Тогда
		ШаблонТекста = НСтр("ru = 'Добавлено субконто ""%1""'");
	ИначеЕсли Изменение = -1 Тогда
		ШаблонТекста = НСтр("ru = 'Удалено субконто ""%1""'");
	Иначе
		ШаблонТекста = НСтр("ru = 'Изменено субконто ""%1""'");
	КонецЕсли;
	
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, ВидСубконто);
	ПротоколИзменений.Добавить(Текст);
		
КонецПроцедуры

Процедура ДобавитьВПротоколИзменениеПризнакаУчета(ПротоколИзменений, ВидСубконто, ПризнакУчета, Изменение)
	
	// В интерфейсе признаки учета называем "видами"
	Если Изменение = 1 Тогда
		ШаблонТекста = НСтр("ru = 'У субконто ""%1"" установлен вид учета %2'");
	ИначеЕсли Изменение = -1 Тогда
		ШаблонТекста = НСтр("ru = 'У субконто ""%1"" снят вид учета %2'");
	Иначе
		ШаблонТекста = НСтр("ru = 'У субконто ""%1"" изменен вид учета %2'");
	КонецЕсли;
	
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, ВидСубконто, ПризнакУчета);
	ПротоколИзменений.Добавить(Текст);
		
КонецПроцедуры

Функция СобытиеЖурналаРегистрацииПараметрыУчета() Экспорт

	Возврат НСтр("ru = 'Настройка параметров учета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())

КонецФункции

#КонецОбласти

#КонецЕсли
