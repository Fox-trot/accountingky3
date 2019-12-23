﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".

//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	БухгалтерскиеОтчеты.ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

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

	// Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	// Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	// Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	// Основной цикл вывода отчета
	Пока Истина Цикл
		// Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			// Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, ДокументРезультат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета, ПараметрыОтчета.ИдентификаторОтчета, ДокументРезультат);

	// СтандартныеПодсистемы.РассылкаОтчетов
	ОтчетПустой = ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновки);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	// Конец СтандартныеПодсистемы.РассылкаОтчетов

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
	
	Заголовок = НСтр("ru = 'Авансовый отчет'");
	НачалоПериода = Дата(1,1,1);
	КонецПериода = Дата(1,1,1);
	ВыводитьПодписи = Ложь;
	Счет = Неопределено;
	Подотчетник = Неопределено;
	Организация = Неопределено;
	
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
	
	ПараметрВывода = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Счет"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Счет = ПараметрВывода.Значение;
	КонецЕсли;
	
	ПараметрВывода = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Подотчетник"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Подотчетник = ПараметрВывода.Значение;
	КонецЕсли;
	
	ОтборДанных = НастройкиОтчета.Отбор.Элементы;
	Для каждого Элемент Из ОтборДанных Цикл
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") И ЗначениеЗаполнено(Элемент.ПравоеЗначение) Тогда
			Организация = Элемент.ПравоеЗначение;
			
			Руководители = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Организация, КонецПериода);
			Руководитель 			= Руководители.Руководитель;
			РуководительДолжность   = Руководители.РуководительДолжность;
			
			ПараметрВывода = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Руководитель"));
			Если ПараметрВывода <> Неопределено Тогда
				ПараметрВывода.Использование = Истина;
				ПараметрВывода.Значение = Руководитель;
			КонецЕсли;
			
			ПараметрВывода = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РуководительДолжность"));
			Если ПараметрВывода <> Неопределено Тогда
				ПараметрВывода.Использование = Истина;
				ПараметрВывода.Значение = РуководительДолжность;
			КонецЕсли;
			Прервать;
		Иначе
			ПараметрВывода = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Руководитель"));
			Если ПараметрВывода <> Неопределено Тогда
				ПараметрВывода.Значение = "";
			КонецЕсли;
			
			ПараметрВывода = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РуководительДолжность"));
			Если ПараметрВывода <> Неопределено Тогда
				ПараметрВывода.Значение = "";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОбороты.СуммаОборот КАК СуммаОборот
	               |ПОМЕСТИТЬ ВТ_1
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(
	               |			&НачалоПериода,
	               |			&КонецПериода,
	               |			,
	               |			Счет <> &ПарныйСчет,
	               |			,
	               |			Субконто1 = &Подотчетник
	               |				И Организация = &Организация,
	               |			КорСчет = &Счет,
	               |			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций)) КАК ХозрасчетныйОбороты
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ХозрасчетныйОбороты.СуммаОборот
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(
	               |			&НачалоПериода,
	               |			&КонецПериода,
	               |			,
	               |			Счет <> &Счет,
	               |			,
	               |			Субконто1 = &Подотчетник
	               |				И Организация = &Организация,
	               |			КорСчет = &ПарныйСчет,
	               |			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций)) КАК ХозрасчетныйОбороты
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(ВТ_1.СуммаОборот) КАК ИзрасходованоСуммаОборот
	               |ИЗ
	               |	ВТ_1 КАК ВТ_1";
	Если Не ЗначениеЗаполнено(Счет) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Счет <> &ПарныйСчет", "Истина");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "КорСчет = &Счет", "Истина");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Счет <> &Счет", "Истина");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "КорСчет = &ПарныйСчет", "Истина");
	Иначе	
		Запрос.УстановитьПараметр("Счет", Счет);
		Запрос.УстановитьПараметр("ПарныйСчет", Счет.ПарныйСчет);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Подотчетник) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто1 = &Подотчетник", "Истина");
	Иначе
		Запрос.УстановитьПараметр("Подотчетник", Подотчетник);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация = &Организация", "Истина");
	Иначе
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПараметрВывода = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтчетВСумме"));
	Если Выборка.Следующий() Тогда
		Если ПараметрВывода <> Неопределено Тогда
			ПараметрВывода.Использование = Истина;
			ПараметрВывода.Значение = Выборка.ИзрасходованоСуммаОборот;
		КонецЕсли;
	Иначе
		Если ПараметрВывода <> Неопределено Тогда
			ПараметрВывода.Значение = 0;
		КонецЕсли;
	КонецЕсли;	
		
	ПараметрыОтчета = Новый Структура;        
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоПериода); 
	ПараметрыОтчета.Вставить("КонецПериода", КонецПериода);
	ПараметрыОтчета.Вставить("ВыводитьПодписи", ВыводитьПодписи);
	ПараметрыОтчета.Вставить("Заголовок", Заголовок);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета", "АвансовыйОтчетЗаМесяц");
	ПараметрыОтчета.Вставить("НастройкиОтчета", НастройкиОтчета);
		
	Возврат ПараметрыОтчета;
КонецФункции

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли