﻿
&НаКлиенте
Процедура Поиск(Команда)
	
	Если СтрокаПоискаПоНаименованию = "" И СтрокаПоискаПоКоду = "" Тогда
		ТекстСообщения = НСтр("ru = 'Ни одна строка поиска не заполнена!'");      
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;	
		
	ЗаполнитьКлассификатор(ПолныйПутьКМакету, ИмяСправочника, Истина)
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПоиск(Команда)
	
	СтрокаПоискаПоНаименованию = "";
	СтрокаПоискаПоКоду 		   = "";
	ЗаполнитьКлассификатор(ПолныйПутьКМакету, ИмяСправочника);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	             
	Параметры.Свойство("Заголовок", Заголовок);
	Параметры.Свойство("ИмяСправочника", ИмяСправочника);
	Параметры.Свойство("ПолныйПутьКМакету", ПолныйПутьКМакету);
	Параметры.Свойство("ИмяЭкспортнойПроцедуры", ИмяЭкспортнойПроцедуры);
	
	СправочникМетаданные = Метаданные.Справочники[ИмяСправочника];
	
	СоответствиеПолей = Новый Соответствие;
	Если НЕ СправочникМетаданные.ДлинаКода = 0 Тогда 
		СоответствиеПолей.Вставить("Code", "Код");
	Иначе 
		Элементы.СтрокаПоискаПоКоду.Видимость = Ложь;
	КонецЕсли;
	Если НЕ СправочникМетаданные.ДлинаНаименования = 0 Тогда 
		СоответствиеПолей.Вставить("Name", "Наименование");
	Иначе 
		Элементы.СтрокаПоискаПоНаименованию.Видимость = Ложь;
	КонецЕсли;	
	
	Если Параметры.Свойство("СоответствиеПолей") Тогда		
		// Дополнительные реквизиты
		Реквизиты = Новый Массив;
		ТипЗначенияСтрока = ОбщегоНазначения.ОписаниеТипаСтрока(0);
		
		Для каждого ЭлементСоответствия Из Параметры.СоответствиеПолей Цикл
			СоответствиеПолей.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение);
			Реквизиты.Добавить(Новый РеквизитФормы(ЭлементСоответствия.Ключ, ТипЗначенияСтрока, "Классификатор"));
		КонецЦикла;
		
		ИзменитьРеквизиты(Реквизиты);
		
		// Отображение дополнительных полей
		Для каждого ЭлементСоответствия Из Параметры.СоответствиеПолей Цикл
			НовыйЭлементФормы = Элементы.Добавить("Колонка" + ЭлементСоответствия.Ключ, Тип("ПолеФормы"), Элементы.Классификатор);
			НовыйЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
			НовыйЭлементФормы.ПутьКДанным = "Классификатор" + "." + ЭлементСоответствия.Ключ;
			НовыйЭлементФормы.Заголовок = ЭлементСоответствия.Ключ;
			НовыйЭлементФормы.ТолькоПросмотр = Истина;
			НовыйЭлементФормы.Ширина = 20;
		КонецЦикла;
	КонецЕсли; 
	
	СоответствиеПолейКлассификатораРеквизитам = Новый ФиксированноеСоответствие(СоответствиеПолей);
	
	ЗаполнитьКлассификатор(ПолныйПутьКМакету, ИмяСправочника);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();

КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗагруженВесьКлассификатор() Тогда
		Отказ = Истина;
		СообщитьОЗагруженностиВсегоКлассификатора();
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Классификатор

// Загружает Выбранную строку классификатора
//
&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	МассивЗагруженных = Новый Массив;

	Если Элемент.ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 Тогда
		Если Элементы.Классификатор.Развернут(Элемент.ТекущаяСтрока) Тогда
			Элементы.Классификатор.Свернуть(Элемент.ТекущаяСтрока);
		Иначе
			Элементы.Классификатор.Развернуть(Элемент.ТекущаяСтрока);
		КонецЕсли;
	Иначе
		ЗагрузитьСтрокуКлассификатораПоИдентификатору(Элемент.ТекущаяСтрока, МассивЗагруженных);
	КонецЕсли;
	
	ТекстОповещения = НСтр("ru = 'Добавлен новый элемент'");
	Для Каждого ЭлеменМассива Из МассивЗагруженных Цикл 
		ПоказатьОповещениеПользователя(ТекстОповещения,, ЭлеменМассива, БиблиотекаКартинок.Информация32);
	КонецЦикла;	
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КлассификаторКод",	"Видимость", ЕстьКод);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КлассификаторНаименование",	"Видимость", ЕстьНаименование);
КонецПроцедуры 

&НаКлиенте
Процедура СообщитьОЗагруженностиВсегоКлассификатора()
	ТекстПредупреждения = НСтр("ru = 'Загружен весь классификатор'");
	ПоказатьПредупреждение(, ТекстПредупреждения, , НСтр("ru = 'Загрузка классификатора'"));
КонецПроцедуры

// Загружает классификатор из макета в дерево значений
//
&НаСервере
Процедура ЗаполнитьКлассификатор(ПолныйПутьКМакету, ИмяЗагружаемогоСправочника, Отбор = Ложь)
	
	ОтображатьЭлементыУправлениеИерархией = Ложь;
	
	МассивРанееЗагруженных  = Новый Массив;
	Запрос = Новый Запрос;
	
	ОписаниеПолейЗапроса = "";
	
	РеквизитКод = СоответствиеПолейКлассификатораРеквизитам.Получить("Code");
	ЕстьКод = НЕ ПустаяСтрока(РеквизитКод);
	Если ЕстьКод Тогда
		ОписаниеПолейЗапроса = "Классификатор." + РеквизитКод + " КАК Код";
	КонецЕсли;
	
	РеквизитНаименование = СоответствиеПолейКлассификатораРеквизитам.Получить("Name");
	ЕстьНаименование = НЕ ПустаяСтрока(РеквизитНаименование);
	Если ЕстьНаименование Тогда
		ОписаниеПолейЗапроса = ?(ПустаяСтрока(ОписаниеПолейЗапроса), "", ОписаниеПолейЗапроса + "," + Символы.ПС) +
			"Классификатор." + РеквизитНаименование + " КАК Наименование";
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ОписаниеПолейЗапроса
	|ИЗ
	|	Справочник." + ИмяЗагружаемогоСправочника + " КАК Классификатор";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОписаниеПолейЗапроса", ОписаниеПолейЗапроса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаИдентификатор = "";
		
		Если ЕстьКод Тогда
			СтрокаИдентификатор = СокрЛП(Выборка.Код);
		КонецЕсли; 
		
		Если ЕстьНаименование Тогда
			СтрокаИдентификатор = СтрокаИдентификатор + СокрЛП(Выборка.Наименование);
		КонецЕсли; 
		
		Если ПустаяСтрока(СтрокаИдентификатор) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивРанееЗагруженных.Добавить(СтрокаИдентификатор);
		
	КонецЦикла;
	
	КоллекцияВерхнегоУровня = Классификатор.ПолучитьЭлементы();
	
	МенеджерСправочника = Справочники[ИмяЗагружаемогоСправочника];
	
	КлассификаторXML = ПолучитьМакетКлассификатора(ПолныйПутьКМакету).ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	ЕстьПолеКод = КлассификаторТаблица.Колонки.Найти("Code") <> Неопределено;
	ЕстьПолеУровень = КлассификаторТаблица.Колонки.Найти("Level") <> Неопределено;
	ЕстьПолеНаименование = КлассификаторТаблица.Колонки.Найти("Name") <> Неопределено;
	
	МассивРодителей = Новый Массив(50);
	ТекущийУровень = 0;
	
	ОчиститьДеревоЗначений = Истина;
	
	Для Каждого СтрокаКлассификаторТаблица Из КлассификаторТаблица Цикл
		
		Если Отбор Тогда
			
			ДлинаСтрокиПоиска = СтрДлина(СтрокаПоискаПоНаименованию);
			
			Если (ЕстьПолеНаименование И СтрНайти(ВРЕГ(СтрокаКлассификаторТаблица.Name), ВРЕГ(СтрокаПоискаПоНаименованию)) = 0) 
				ИЛИ (ЕстьПолеКод И СтрНайти(СтрокаКлассификаторТаблица.Code, СтрокаПоискаПоКоду) = 0) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ЕстьПолеУровень И НЕ Отбор Тогда
			
			ТекущийУровень = Число(СтрокаКлассификаторТаблица.Level);
			Если ТекущийУровень = 0 Тогда
				КоллекцияРодителя = Классификатор.ПолучитьЭлементы();
			Иначе 
				
				Родитель = МассивРодителей[ТекущийУровень - 1];
				Родитель.ИндексКартинки = 0;
				КоллекцияРодителя = Родитель.ПолучитьЭлементы();
				ОтображатьЭлементыУправлениеИерархией = Истина;
				
			КонецЕсли;
			
		Иначе
			КоллекцияРодителя = Классификатор.ПолучитьЭлементы();
		КонецЕсли; 
		
		Если ОчиститьДеревоЗначений Тогда
			КоллекцияРодителя.Очистить();
		КонецЕсли;
		
		Если Отбор И ЕстьПолеКод Тогда			
			ДлинаКода = СтрДлина(СтрокаКлассификаторТаблица.Code);
			ВременныйКодРодителя = "";
			КодПоиска = "";
			
			Для Символ = 1 По ДлинаКода Цикл
				
				ВыделяемыйСимвол = Сред(СтрокаКлассификаторТаблица.Code, Символ, 1);
				
				Если ВыделяемыйСимвол <> "0" Тогда
					ВременныйКодРодителя = ВременныйКодРодителя + ВыделяемыйСимвол;
				Иначе
					ДлинаКодаРодителя = СтрДлина(ВременныйКодРодителя);
					КодРодителяБезНулей = Лев(ВременныйКодРодителя, ДлинаКодаРодителя - 1);
					ДлинаКодаРодителяБезНулей = СтрДлина(КодРодителяБезНулей);
					КоличествоНулей = 8 - ДлинаКодаРодителяБезНулей; 
					
					Для ДобавляемыйНуль = 1 По КоличествоНулей Цикл
						КодРодителяБезНулей = КодРодителяБезНулей + "0";	
					КонецЦикла;
					
					КодПоиска = КодРодителяБезНулей;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
			
			Если КодПоиска <> "" Тогда				
				ЭлементыКлассификатора = Классификатор.ПолучитьЭлементы();
				
				Индекс = 0;
				Для Каждого Элемент Из ЭлементыКлассификатора Цикл
					Если КодПоиска = Элемент.Код Тогда
						ЭлементыКлассификатора.Удалить(Индекс);
						Прервать;
					КонецЕсли;
					
					Индекс = Индекс + 1;
				КонецЦикла;				
			КонецЕсли;	
		КонецЕсли;	
		
		СтрокаИдентификатор = "";
		НоваяЗаписьКлассификатора = КоллекцияРодителя.Добавить();
		
		Для каждого ЭлементСоответствия Из СоответствиеПолейКлассификатораРеквизитам Цикл
			
			Если НЕ ПустаяСтрока(ЭлементСоответствия.Значение) Тогда
				НоваяЗаписьКлассификатора.ЗначенияПолейСтрокиКлассификатора.Добавить(
					СтрокаКлассификаторТаблица[ЭлементСоответствия.Ключ],
					ЭлементСоответствия.Значение);
			КонецЕсли; 
				
		КонецЦикла;
		
		Если ЕстьПолеКод Тогда
			
			НоваяЗаписьКлассификатора.Код =	СокрЛП(СтрокаКлассификаторТаблица.Code);
			Если ЕстьКод Тогда
				СтрокаИдентификатор = НоваяЗаписьКлассификатора.Код;
			КонецЕсли; 
			
		КонецЕсли;
		
		Если ЕстьПолеНаименование Тогда
			
			НоваяЗаписьКлассификатора.Наименование = СокрЛП(СтрокаКлассификаторТаблица.Name);
			СтрокаИдентификатор = СтрокаИдентификатор + НоваяЗаписьКлассификатора.Наименование;
			
		КонецЕсли;
		
		// Заполнение дополнительных полей
		Для каждого ЭлементСоответствия Из СоответствиеПолейКлассификатораРеквизитам Цикл
			Если ЭлементСоответствия.Ключ = "Code"
				Или ЭлементСоответствия.Ключ = "Name" Тогда 
				Продолжить;
			КонецЕсли;	
			
			НоваяЗаписьКлассификатора[ЭлементСоответствия.Ключ] = СтрокаКлассификаторТаблица[ЭлементСоответствия.Ключ];
		КонецЦикла;
		
		НоваяЗаписьКлассификатора.ИндексКартинки = 2;
		
		Если МассивРанееЗагруженных.Найти(СтрокаИдентификатор) <> Неопределено Тогда
			НоваяЗаписьКлассификатора.Загружен = Истина;
		КонецЕсли;
		
		МассивРодителей[ТекущийУровень] = НоваяЗаписьКлассификатора;
		
		ОчиститьДеревоЗначений = Ложь;	
	КонецЦикла;
	
	Если ОчиститьДеревоЗначений Тогда
		ТекстСообщения = НСтр("ru = 'Ни найдено ни одной строки!'");      
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Элементы.КлассификаторДерево.Видимость = ОтображатьЭлементыУправлениеИерархией;
	Элементы.КлассификаторСписок.Видимость = ОтображатьЭлементыУправлениеИерархией;

КонецПроцедуры

&НаСервере
Функция ПолучитьМакетКлассификатора(ПолныйПутьКМакету)
	
	ЧастиПути = СтрЗаменить(ПолныйПутьКМакету, ".", Символы.ПС);
	
	Если СтрЧислоСтрок(ЧастиПути) = 3 Тогда
		ПутьКМетаданным = СтрПолучитьСтроку(ЧастиПути, 1) + "." + СтрПолучитьСтроку(ЧастиПути, 2);
		ПутьКОбъектуМетаданных = СтрПолучитьСтроку(ЧастиПути, 3);
	ИначеЕсли СтрЧислоСтрок(ЧастиПути) = 2 Тогда
		ПутьКМетаданным = СтрПолучитьСтроку(ЧастиПути, 1);
		ПутьКОбъектуМетаданных = СтрПолучитьСтроку(ЧастиПути, 2);
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Макет классификатора ""%1"" не найден. Операция прервана.'"), ПолныйПутьКМакету);
	КонецЕсли;
	
	Если СтрЧислоСтрок(ЧастиПути) = 3 Тогда
		Макет = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПутьКМетаданным).ПолучитьМакет(ПутьКОбъектуМетаданных);
	Иначе
		Макет = ПолучитьОбщийМакет(ПутьКОбъектуМетаданных);
	КонецЕсли;
	
    Возврат Макет;
	
КонецФункции

// Загружает весь классификатор
&НаСервере
Процедура ЗагрузитьВсе()
	ЗагрузитьСтрокуКлассификатора(Классификатор);
КонецПроцедуры

// Загружает отмеченные строки классификатора
//
&НаСервере
Процедура ЗагрузитьТекущий(МассивЗагруженных)
	Для Каждого ВыделеннаяСтрока Из Элементы.Классификатор.ВыделенныеСтроки Цикл
		ЗагрузитьСтрокуКлассификатораПоИдентификатору(ВыделеннаяСтрока, МассивЗагруженных);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтрокуКлассификатораПоИдентификатору(ИдентификаторТекущейСтроки, МассивЗагруженных)
	НайденнаяСтрока = Классификатор.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	Если НайденнаяСтрока <> Неопределено Тогда
		ЗагрузитьСтрокуКлассификатора(НайденнаяСтрока);
		Если ЕстьНаименование Тогда 
			МассивЗагруженных.Добавить(НайденнаяСтрока.Наименование);
		КонецЕсли;	
	КонецЕсли; 
КонецПроцедуры

// Загружает строку классификатора, если передана строка, содержащая строки
// производит рекурсивную загрузку этих строк
&НаСервере
Процедура ЗагрузитьСтрокуКлассификатора(ЗагружаемыйЭлемент)
	
	Если ЗагружаемыйЭлемент.ПолучитьЭлементы().Количество() > 0 Тогда
		
		Для Каждого СтрокаКоллекции Из ЗагружаемыйЭлемент.ПолучитьЭлементы() Цикл
			ЗагрузитьСтрокуКлассификатора(СтрокаКоллекции);
		КонецЦикла;
		
	ИначеЕсли НЕ ЗагружаемыйЭлемент.Загружен Тогда
		
		НовыйОбъектСсылка = Справочники[ИмяСправочника].ПолучитьСсылку(Новый УникальныйИдентификатор);
		НовыйОбъект = Справочники[ИмяСправочника].СоздатьЭлемент();
		НовыйОбъект.УстановитьСсылкуНового(НовыйОбъектСсылка);
		НовыйОбъектМетаданные = НовыйОбъект.Метаданные();
		
		Для каждого ЭлементСписка Из ЗагружаемыйЭлемент.ЗначенияПолейСтрокиКлассификатора Цикл
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта(ЭлементСписка.Представление, НовыйОбъектМетаданные)
				Или ЭлементСписка.Представление = "Наименование"
				Или ЭлементСписка.Представление = "Код" Тогда 
				НовыйОбъект[ЭлементСписка.Представление] = ЭлементСписка.Значение;
			КонецЕсли;	
		КонецЦикла;
		
		НовыйОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
		
		Попытка
			НовыйОбъект.Записать();
			ЗагружаемыйЭлемент.Загружен = Истина;
			
			// Дополнительная обработка после загрузки.
			Если ЗначениеЗаполнено(ИмяЭкспортнойПроцедуры) Тогда
				ДополнительныеПараметры = Новый Структура;
				Для каждого ЭлементСписка Из ЗагружаемыйЭлемент.ЗначенияПолейСтрокиКлассификатора Цикл
					ДополнительныеПараметры.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
				КонецЦикла;
				ДополнительныеПараметры.Вставить("Ссылка", НовыйОбъектСсылка);
				ПараметрыЭкспортнойПроцедуры = Новый Массив;
				ПараметрыЭкспортнойПроцедуры.Добавить(ДополнительныеПараметры);
				ОбщегоНазначения.ВыполнитьМетодКонфигурации(СокрЛП(ИмяЭкспортнойПроцедуры), ПараметрыЭкспортнойПроцедуры);
			КонецЕсли;			
		Исключение
			ВызватьИсключение СтрШаблон(
				НСтр("ru = 'Не удалось загрузить элемент %1 (код: %2)'"),
				ЗагружаемыйЭлемент.Наименование,
				ЗагружаемыйЭлемент.Код);
		КонецПопытки;
			
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, на предмет загрузки всего классификатора
//
&НаКлиенте
Функция ЗагруженВесьКлассификатор()
	Возврат ЗагруженыСтроки(Классификатор.ПолучитьЭлементы());
КонецФункции

// Проверяет коллекцию строк на предмет загруженности
//
&НаКлиенте
Функция ЗагруженыСтроки(КоллекцияСтрок)
	Для Каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		Если СтрокаКоллекции.ПолучитьЭлементы().Количество() > 0 Тогда
			РезультатПроверки = ЗагруженыСтроки(СтрокаКоллекции.ПолучитьЭлементы());
		Иначе
			РезультатПроверки = СтрокаКоллекции.Загружен;
		КонецЕсли;
		Если НЕ РезультатПроверки Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	МассивЗагруженных = Новый Массив;
	ЗагрузитьТекущий(МассивЗагруженных);
	
	ТекстОповещения = НСтр("ru = 'Добавлен новый элемент'");
	Для Каждого ЭлеменМассива Из МассивЗагруженных Цикл 
		ПоказатьОповещениеПользователя(ТекстОповещения,, ЭлеменМассива, БиблиотекаКартинок.Информация32);
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьВсе(Команда)
	ЗагрузитьВсе();
	СообщитьОЗагруженностиВсегоКлассификатора();
	Закрыть();
КонецПроцедуры
