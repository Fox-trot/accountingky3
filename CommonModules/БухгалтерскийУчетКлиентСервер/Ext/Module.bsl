﻿
//Процедура выполняет проверку корректности введенных ИНН
//Принимает на вход структуру
// Параметры передачи - структура
// Обязательные ключи структуры
//	ИНН
//	ЭтоЮрЛицо
//	ОшибокПоИННнет
//
//Возвращает структуру с переменным набором ключей 
//только со значениями соответствующими результату проверки.
Функция ПроверитьКорректностьИНН(Знач СтруктураПараметров) Экспорт
	// 1. Заполненость ИНН если нет то дальнейшие проверки не нужны
	// 2. Для спр. Контрагенты и спр. ФизЛица д.б. длина ИНН = 14, если нет то дальнейшие проверки не нужны
	// 3. ИНН должен состоять только из цифр
	// 4. Проверка тип контрагента для спр. Контаргенты
	// 5. Для спр. Контрагенты вид контрагента ЮрЛицо
	// 5.1 Проверка 1-й цифры - не больше 5
	// 5.2 Проверка дня месяца
	// 5.3 Проверка месяца
	// 5.4 Проверка года < 1901
	// 6. Для спр. Контрагенты вид контрагента ФизЛицо и спр. ФизЛица
	// 6.1 Проверка 1-ой цифры - 1 или 2
	// 6.2 Проверка соответствия ИНН дню рождения
	// 6.3 Проверка корректности месяца рождения в ИНН 
	// 6.4 Проверка корректности года рождения в ИНН
	// 6.5 Проверка соответствует ли указаная дата рождения дате рождения в ИНН
	
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ИННВведенКорректно",               Истина);
	СтруктураВозврата.Вставить("РасширенноеПредставлениеИНН",      СтруктураПараметров.ИНН);
	СтруктураВозврата.Вставить("НадписьПоясненияНекорректногоИНН", "");
	СтруктураВозврата.Вставить("ПустойИНН",                        Ложь);
	СтруктураВозврата.Вставить("ОшибокПоИННнет",                   СтруктураПараметров.ПроверитьИНН);
	
	ИНН      = СокрП(СтруктураПараметров.ИНН);
	ДлинаИНН = СтрДлина(ИНН);
	Если НЕ ЗначениеЗаполнено(ИНН) Тогда
		// 1. Заполненость ИНН если нет то дальнейшие проверки не нужны
		СтруктураВозврата.ИННВведенКорректно = Ложь;
		СтруктураВозврата.ПустойИНН 		 = Истина;
		СтруктураВозврата.ОшибокПоИННнет	 = Ложь;
	Иначе	
		Если Не ДлинаИНН = 14 Тогда 
			// 2. Для спр. Контрагенты и спр. ФизЛица д.б. длина ИНН = 14, если нет то дальнейшие проверки не нужны
			СтруктураВозврата.НадписьПоясненияНекорректногоИНН = "Длина ИНН должна быть 14 знаков";
			СтруктураВозврата.ИННВведенКорректно = Ложь;
			СтруктураВозврата.ОшибокПоИННнет	 = Ложь;
			ТекстДляНекорректногоИНН = НСтр("ru = '%1
			|ИНН содержит не 14 цифр'");
			СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
		КонецЕсли		
		
	КонецЕсли;
	
	Если СтруктураВозврата.ОшибокПоИННнет Тогда
		
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ИНН) Тогда
			// 3. ИНН должен состоять только из цифр
			СтруктураВозврата.ИННВведенКорректно = Ложь;
			СтруктураВозврата.НадписьПоясненияНекорректногоИНН = НСтр("ru = 'ИНН должен включать только цифры'");
			ТекстДляНекорректногоИНН = НСтр("ru = '%1
			|ИНН содержит не только цифры'");
			СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
			СтруктураВозврата.ОшибокПоИННнет = Ложь;
		КонецЕсли
		
	КонецЕсли;
	
	
	Если СтруктураВозврата.ОшибокПоИННнет Тогда
		
		Если СтруктураПараметров.ЭтоЮрлицо = Неопределено ТОгда 
			// 4. Проверка тип контрагента для спр. Контаргенты
			СтруктураВозврата.ИННВведенКорректно = Ложь;
			СтруктураВозврата.НадписьПоясненияНекорректногоИНН = НСтр("ru = 'Неизвестен вид контрагента. Укажите вид контрагента'");
			СтруктураВозврата.ОшибокПоИННнет = Ложь;	
		КонецЕсли
		
	КонецЕсли;	
	
	Если СтруктураВозврата.ОшибокПоИННнет Тогда
		// 5. Для спр. Контрагенты вид контрагента ЮрЛицо
		
		Если НЕ СтруктураПараметров.ПроверитьИНН Тогда 
			СтруктураВозврата.ИННВведенКорректно = Ложь;
			СтруктураВозврата.ОшибокПоИННнет 	 = Ложь;	
		КонецЕсли;
		
		
		Если СтруктураПараметров.ЭтоЮрлицо Тогда
			// 5.1 Проверка 1-й цифры - не больше 5
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				
				ПерваяЦифра = Число(Лев(ИНН,1));
				Если ПерваяЦифра > 5 Тогда 
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = НСтр("ru = 'Первая цифра ИНН не может быть больше 5'");
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
					СтруктураВозврата.ОшибокПоИННнет = Ложь;
				КонецЕсли;
				
			КонецЕсли;
			// 5.2 Проверка дня месяца
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				
				ДеньМесяца = Число(Сред(ИНН,2,2));
				Если ДеньМесяца > 31 
					ИЛИ ДеньМесяца = 0 Тогда 
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = НСтр("ru = 'Вторая и третья цифры ИНН должны соответствовать дню месяца даты регистрации'");
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
					СтруктураВозврата.ОшибокПоИННнет = Ложь;
				КонецЕсли;
				
			КонецЕсли;
			// 5.3 Проверка месяца
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				
				Месяц = Число(Сред(ИНН,4,2));
				Если Месяц > 12 
					ИЛИ Месяц = 0 Тогда 
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = НСтр("ru = 'Четвертая и пятая цифры ИНН должны соответствовать месяцу даты регистрации'");
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
					СтруктураВозврата.ОшибокПоИННнет = Ложь;
				КонецЕсли;
				
			КонецЕсли;
			// 5.4 Проверка года < 1901
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				
				ГодИНН = Число(Сред(ИНН,6,4));
				Если ПерваяЦифра = 0 
					И (ГодИНН < 1901 ИЛИ ГодИНН > Год(ТекущаяДата())) Тогда 
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = НСтр("ru = 'Цифры с шестой по девятую ИНН должны соответствовать году регистрации'");
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
					СтруктураВозврата.ОшибокПоИННнет = Ложь;
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			// 6. Для спр. Контрагенты вид контрагента ФизЛицо и спр. ФизЛица
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				// 6.1 проверка 1-ой цифры - 1 или 2
				Если Не Лев(СтруктураПараметров.ИНН,1) = "1" и Не Лев(СтруктураПараметров.ИНН,1) = "2" Тогда 
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.ОшибокПоИННнет     = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = "Первая цифра ИНН должна быть 1 для женщин или 2 для мужчин";
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
				КонецЕсли;
				
			КонецЕсли;
			
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				// 6.2 Проверка соответствия ИНН дню рождения
				ДеньМесяца = Число(Сред(СтруктураПараметров.ИНН,2,2));
				Если ДеньМесяца > 31 ИЛИ ДеньМесяца = 0 Тогда
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.ОшибокПоИННнет     = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = "Вторая и третья цифра ИНН должно соответствовать дню рождения физлица";
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
				КонецЕсли;
				
			КонецЕсли;
			
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				// 6.3 Проверка корректности месяца рождения в ИНН 
				Месяц = Число(Сред(СтруктураПараметров.ИНН,4,2));
				Если Месяц > 12 ИЛИ Месяц = 0 Тогда
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.ОшибокПоИННнет     = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = "Четвертая и пятая цифра ИНН должно соответствовать месяцу рождения";
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
				КонецЕсли;
				
			КонецЕсли;
			
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				// 6.4  Проверка корректности года рождения в ИНН
				ГодИНН = Число(Сред(СтруктураПараметров.ИНН,6,4));
				Если ГодИНН < 1901 ИЛИ ГодИНН > Год(ТекущаяДата()) тогда
					СтруктураВозврата.ИННВведенКорректно = Ложь;
					СтруктураВозврата.ОшибокПоИННнет     = Ложь;
					СтруктураВозврата.НадписьПоясненияНекорректногоИНН = "Цифры ИНН с 6 по 9 должно соответствовать году рождения"; 
					ТекстДляНекорректногоИНН = НСтр("ru = '%1
					|ИНН не соответствует формату'");
					СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
				КонецЕсли;
				
			КонецЕсли;
			
			Если СтруктураВозврата.ОшибокПоИННнет Тогда
				// 6.5 Проверка соответствует ли указаная дата рождения дате рождения в ИНН
				ДатаИНН = Дата(Сред(СтруктураПараметров.ИНН,6,4) + Сред(СтруктураПараметров.ИНН,4,2) + Сред(СтруктураПараметров.ИНН,2,2));
				Если ЗначениеЗаполнено(СтруктураПараметров.ДатаРождения) Тогда 
					
					Если Не ДатаИНН = СтруктураПараметров.ДатаРождения Тогда 
						СтруктураВозврата.ИННВведенКорректно = Ложь;
						СтруктураВозврата.ОшибокПоИННнет     = Ложь;
						СтруктураВозврата.НадписьПоясненияНекорректногоИНН = "Дата рождения ФизЛица должна совпадать с датой рождения в его ИНН";	
						ТекстДляНекорректногоИНН = НСтр("ru = '%1
						|ИНН не соответствует формату'");
						СтруктураВозврата.РасширенноеПредставлениеИНН = СтрШаблон(ТекстДляНекорректногоИНН, ИНН);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;	
	Возврат СтруктураВозврата;
	
КонецФункции	

// Процедура записывает переданный справочник объект и выводит сообщение.
// Предназначена для вызова из процедур заполнения и обработки справочников информационной базы.
//
// Параметры:
//  СправочникОбъект - объект, который требуется записать.
//
Процедура ЗаписатьСправочникОбъект(СправочникОбъект, Сообщать = Ложь, Оповещать = Ложь, Отказ = Ложь) Экспорт

	Если НЕ СправочникОбъект.Модифицированность() Тогда
		Возврат;
	КонецЕсли;

	Если СправочникОбъект.ЭтоНовый() Тогда
		Если СправочникОбъект.ЭтоГруппа Тогда
			СтрСообщения = НСтр("ru = 'Создана группа справочника ""%1"", код: ""%2"", наименование: ""%3""'") ;
		Иначе
			СтрСообщения = НСтр("ru = 'Создан элемент справочника ""%1"", код: ""%2"", наименование: ""%3""'") ;
		КонецЕсли;
		
		ТекстОповещения = НСтр("ru = 'Добавление'")
	Иначе
		Если СправочникОбъект.ЭтоГруппа Тогда
			СтрСообщения = НСтр("ru = 'Обработана группа справочника ""%1"", код: ""%2"", наименование: ""%3""'") ;
		Иначе
			СтрСообщения = НСтр("ru = 'Обработан элемент справочника ""%1"", код: ""%2"", наименование: ""%3""'") ;
		КонецЕсли; 
		
		ТекстОповещения = НСтр("ru = 'Изменение'")
	КонецЕсли;

	Если СправочникОбъект.Метаданные().ДлинаКода > 0 Тогда
		ПолныйКод = СправочникОбъект.ПолныйКод();
	Иначе
		ПолныйКод = НСтр("ru = '<без кода>'");
	КонецЕсли; 
	СтрСообщения = СтрШаблон(СтрСообщения, СправочникОбъект.Метаданные().Синоним, ПолныйКод, СправочникОбъект.Наименование);

	Попытка
		СправочникОбъект.Записать();
		Если Сообщать = Истина Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрСообщения, СправочникОбъект);	
		КонецЕсли;
		
		Если Оповещать Тогда
			#Если Клиент Тогда
				ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(СправочникОбъект), СтрСообщения, БиблиотекаКартинок.Информация32);
			#КонецЕсли	
		КонецЕсли;	

	Исключение
		Отказ = Истина;
		
		ТекстСообщения = НСтр("ru = 'Не удалось завершить действие: %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, СтрСообщения);

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);

		ОписаниеОшибки = ИнформацияОбОшибке();
		#Если Сервер Тогда
			ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание + "; " + ОписаниеОшибки.Причина.Описание);
		#КонецЕсли	

	КонецПопытки;

КонецПроцедуры

Процедура УстановитьКартинкуДляКомментария(ГруппаДополнительно, Комментарий) Экспорт
	
	Если ЗначениеЗаполнено(Комментарий) Тогда
		ГруппаДополнительно.Картинка = БиблиотекаКартинок.НаписатьSMS;
	Иначе
		ГруппаДополнительно.Картинка = Новый Картинка;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С СУБКОНТО В ФОРМЕ

// Процедура - настраивает связь счета с его субконто в шапке.
//
// Параметры:
//  Форма	 - УправляемаяФорма - форма.
//  Суффикс	 - Строка - суффикс счета. 
//  ИмяСчета - Строка - наименование реквизита.
//  Объект - ДанныеФормыСтруктура - объект.
//  ПоляОбъекта - Структура - структура субконто.
Процедура НастроитьСвязьСчетаИСубконтоВШапке(Форма, Суффикс, ИмяСчета, Объект, ПоляОбъекта = Неопределено) Экспорт

	Если НЕ ПоляОбъекта = Неопределено Тогда
		ПриВыбореСчета(Объект[ИмяСчета], Форма, ПоляОбъекта, ,Ложь);
	КонецЕсли;
	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма, Объект, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	ИзменитьПараметрыВыбораПолейСубконто(Форма, Объект, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента);	

КонецПроцедуры

// Процедура - настраивает связь счета с его субконто в табличной части.
//
// Параметры:
//  Форма	 - УправляемаяФорма - форма.
//  Суффикс	 - Строка - суффикс счета. 
//  ИмяСчета - Строка - наименование реквизита.
//  ИмяТЧ 	 - Строка - наименование табличной части.
//  СтрокаТабличнойЧасти - ДанныеФормыЭлементКоллекции - строка табличной части.
//  ПоляОбъекта - Структура - структура субконто.
Процедура НастроитьСвязьСчетаИСубконтоВТЧ(Форма, Суффикс, ИмяСчета, ИмяТЧ, СтрокаТабличнойЧасти, ПоляОбъекта = Неопределено) Экспорт

	Если НЕ ПоляОбъекта = Неопределено Тогда
		ПриИзмененииСчета(СтрокаТабличнойЧасти[ИмяСчета], СтрокаТабличнойЧасти, ПоляОбъекта, Истина);
	КонецЕсли;
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма.Объект, СтрокаТабличнойЧасти, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	ИзменитьПараметрыВыбораПолейСубконто(Форма, СтрокаТабличнойЧасти, "Субконто" + Суффикс + "%Индекс%", ИмяТЧ + "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента);	

КонецПроцедуры

// Процедура установки типа и доступности субконто в зависимости от выбранного счета
//
Процедура ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей = Неопределено, ЭтоТаблица = Ложь) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если Индекс <= ДанныеСчета.КоличествоСубконто Тогда
			Если ЭтоТаблица Тогда
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа 	= ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ПодсказкаВвода 	= "<" + ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ">";
				КонецЕсли;
			Иначе
				Если Не ЗаголовкиПолей = Неопределено Тогда
					Если ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
						Форма[ЗаголовкиПолей["Субконто" + Индекс]] = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ":";
					КонецЕсли;
				Иначе
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Заголовок = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Доступность     	= Истина;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа 	= ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ПодсказкаВвода 	= "<" + ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ">";
				КонецЕсли;
			КонецЕсли;
		Иначе 
			Если Не ЭтоТаблица Тогда
				Если Не ЗаголовкиПолей = Неопределено Тогда
					Если ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
						Форма[ЗаголовкиПолей["Субконто" + Индекс]] = "";
					КонецЕсли;
				Иначе
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Заголовок = "Субконто "+Индекс;//Совсем пустой заголовок не дает, по этому выводим надпись "Субконто..."
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Доступность     	= Ложь;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа 	= Новый ОписаниеТипов("Неопределено");
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ПодсказкаВвода 	= "";
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Процедура установки типа и доступности субконто в зависимости от выбранного счета
//
Процедура ПриИзмененииСчета(Счет, Объект, ПоляОбъекта, ЭтоТаблица = Ложь, ЗначенияСубконто = Неопределено) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			Если Индекс <= ДанныеСчета.КоличествоСубконто Тогда
				ЗначениеСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"].ПривестиЗначение(Объект[ПоляОбъекта["Субконто" + Индекс]]);
				ЗначениеСубконтоПоУмолчанию = ?(ЗначенияСубконто = Неопределено, ЗначенияСубконто, ЗначенияСубконто.Получить(ДанныеСчета["ВидСубконто" + Индекс]));
				Если ЗначениеЗаполнено(ЗначениеСубконто) ИЛИ (НЕ ЗначениеЗаполнено(ЗначениеСубконтоПоУмолчанию)) Тогда
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконто;
				Иначе
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконтоПоУмолчанию;
				КонецЕсли;
			Иначе 
				Объект[ПоляОбъекта["Субконто" + Индекс]] = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭтоТаблица Тогда
		УстановитьДоступностьСубконто(Счет, Объект, ПоляОбъекта, Истина);
	КонецЕсли;
КонецПроцедуры

// Процедура установки доступности субконто в зависимости от выбранного счета
//
Процедура УстановитьДоступностьСубконто(Счет, Объект, ПоляОбъекта, ЗаполнятьЗаголовокСубконто = Ложь) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = (Индекс <= ДанныеСчета.КоличествоСубконто);
			Если ЗаполнятьЗаголовокСубконто И Объект.Свойство("Вид" + ПоляОбъекта["Субконто" + Индекс]) Тогда
				Объект["Вид" + ПоляОбъекта["Субконто" + Индекс]] = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];//.ПривестиЗначение(Объект[ПоляОбъекта["Субконто" + Индекс]]);				
			КонецЕсли;
		Иначе
			Если ЗаполнятьЗаголовокСубконто И Объект.Свойство("Вид" + ПоляОбъекта["Субконто" + Индекс]) Тогда
				Объект["Вид" + ПоляОбъекта["Субконто" + Индекс]] = "";				
			КонецЕсли;		
		КонецЕсли;
	КонецЦикла;
	
	Если ПоляОбъекта.Свойство("Валютный") Тогда
		Объект[ПоляОбъекта["Валютный"] + "Доступность"] = ДанныеСчета.Валютный;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Количественный") Тогда
		Объект[ПоляОбъекта["Количественный"] + "Доступность"] = ДанныеСчета.Количественный;
	КонецЕсли;
	
КонецПроцедуры

// Функция - Список параметров выбора субконто
//
// Параметры:
//  Форма					 - 	 - 
//  ПараметрыОбъекта		 - 	 - 
//  ШаблонИмяПоляОбъекта	 - 	 - 
//  ИмяРеквизитаСчетаУчета	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция СписокПараметровВыбораСубконто(Форма, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяРеквизитаСчетаУчета) Экспорт

	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	
	СписокПараметров.Вставить("СчетУчета", ПараметрыОбъекта[ИмяРеквизитаСчетаУчета]);
	
	Если ПараметрыОбъекта.Свойство("Организация") Тогда 
		СписокПараметров.Вставить("Организация", ПараметрыОбъекта.Организация);
	Иначе 
		СписокПараметров.Вставить("Организация", БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация"));
	КонецЕсли;
	
	Возврат СписокПараметров;

КонецФункции

Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Объект, ШаблонИмяПоляОбъекта, ШаблонИмяЭлементаФормы, СписокПараметров) Экспорт
	
	ВидыПараметров = Новый Соответствие;
	ВидыПараметров.Вставить(Тип("СправочникСсылка.БанковскиеСчета"), "БанковскийСчет");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.Кассы"), "Касса");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.ПодразделенияОрганизаций"), "Подразделение");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.ДоговорыКонтрагентов"), "Договор");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.Субконто"), "Субконто");
	
	Для Индекс = 1 По 3 Цикл
		ИмяЭлементаФормы = СтрЗаменить(ШаблонИмяЭлементаФормы, "%Индекс%", Индекс);
		ИмяПоляОбъекта   = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", Индекс);
		ТипПоляОбъекта   = ТипЗнч(Объект[ИмяПоляОбъекта]);
		
		ВидПараметра = ВидыПараметров[ТипПоляОбъекта];
		
		Если ВидПараметра = Неопределено Тогда
			Продолжить;
		Иначе
			МассивПараметров = Новый Массив();
			Если ВидПараметра = "БанковскийСчет" Тогда
				Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
				КонецЕсли;
				Если СписокПараметров.Свойство("Контрагент") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Контрагент));
				КонецЕсли;
				Если СписокПараметров.Свойство("ВалютаДенежныхСредств") И ЗначениеЗаполнено(СписокПараметров.ВалютаДенежныхСредств) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", СписокПараметров.ВалютаДенежныхСредств));
				КонецЕсли;
				
			ИначеЕсли ВидПараметра = "Касса" Тогда
				Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
				КонецЕсли;
				
				Если СписокПараметров.Свойство("ВалютаДенежныхСредств") И ЗначениеЗаполнено(СписокПараметров.ВалютаДенежныхСредств) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", СписокПараметров.ВалютаДенежныхСредств));
				КонецЕсли;
				
			ИначеЕсли ВидПараметра = "Подразделение" Тогда
				Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
				КонецЕсли;
				
			ИначеЕсли ВидПараметра = "Договор" Тогда
				Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", СписокПараметров.Организация));
				КонецЕсли;
				Если СписокПараметров.Свойство("Контрагент") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Контрагент));
				КонецЕсли;
				Если СписокПараметров.Свойство("ВидДоговора") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВидДоговора", СписокПараметров.ВидДоговора));
				КонецЕсли;				
				
			ИначеЕсли ВидПараметра = "Субконто"  
				И СписокПараметров.Свойство("СчетУчета") Тогда
				СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СписокПараметров.СчетУчета);
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СвойстваСчета["ВидСубконто" + Индекс]));
			КонецЕсли;
			
			Если МассивПараметров.Количество() > 0 Тогда
				ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
				Форма.Элементы[ИмяЭлементаФормы].ПараметрыВыбора = ПараметрыВыбора;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Процедура изменяет параметры выбора для ПоляВвода управляемой формы:
//
//Параметры:
//	ЭлементФормыСчет - ПолеВвода управляемой формы, для которого изменяется параметр выбора 
//  МассивСчетов                 - <Массив> ИЛИ <Неопределено> - счета, которыми нужно ограничить список. 
//	                                   Если не заполнено - ограничения не будет
//  ОтборПоПризнакуВалютный      - <Булево> ИЛИ <Неопределено> - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнакуЗабалансовый   - <Булево> ИЛИ <Неопределено> - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнакуСчетГруппа    - <Булево> ИЛИ <Неопределено> - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//
//
Процедура ИзменитьПараметрыВыбораСчета(ЭлементФормыСчет, МассивСчетов, ОтборПоПризнакуВалютный = Неопределено, ОтборПоПризнакуЗабалансовый = Неопределено, ОтборПоПризнакуСчетГруппа = Ложь) Экспорт

	МассивОтборов = Новый Массив;
	Если ОтборПоПризнакуСчетГруппа <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", ОтборПоПризнакуСчетГруппа));
	КонецЕсли; 
	
	Если ОтборПоПризнакуВалютный <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Валютный", ОтборПоПризнакуВалютный));
	КонецЕсли; 
	
	Если ОтборПоПризнакуЗабалансовый <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Забалансовый", ОтборПоПризнакуЗабалансовый));
	КонецЕсли; 
	
	Если МассивСчетов <> Неопределено И МассивСчетов.Количество() > 0 Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
	КонецЕсли; 

	ПараметрыВыбора = Новый ФиксированныйМассив(МассивОтборов);
	ЭлементФормыСчет.ПараметрыВыбора = ПараметрыВыбора;
	
КонецПроцедуры
