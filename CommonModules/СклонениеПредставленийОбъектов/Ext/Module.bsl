﻿#Область ПрограммныйИнтерфейс

// Склоняет ФИО
// Только для работы на ОС Windows.
//
// Параметры:
// 	ФИО		- Строка - Строка, в которой содержится ФИО для склонения.
// 	Падеж 	- Число - падеж, в который необходимо просклонять представление объекта.
//							1 - Именительный.
//							2 - Родительный.
//							3 - Дательный.
//							4 - Винительный.
//							5 - Творительный.
//							6 - Предложный.
//	Объект 	- ОбъектСклонения - Ссылка на объект, реквизит которого склоняется.
//	Пол		- Число - Число - пол физического лица, 
//							1 - мужской, 
//							2 - женский.
//
// Возвращаемое значение:
//	Строка - Результат склонения ФИО в падеже.
//
Функция ПросклонятьФИО(ФИО, Падеж, Объект = Неопределено, Пол = Неопределено) Экспорт
	
	Возврат Просклонять(ФИО, Падеж, Объект, Истина, Пол);
	
КонецФункции

// Склоняет представление объекта.
// Только для работы на ОС Windows.
//
// Параметры:
// 	Представление 	- Строка 	- Строка, в которой содержится ФИО для склонения.
// 	Падеж 			- Число  	- падеж, в который необходимо просклонять представление объекта.
//  	               			1 - Именительный.
//                  			2 - Родительный.
//                  			3 - Дательный.
//                  			4 - Винительный.
//                  			5 - Творительный.
//                  			6 - Предложный.
//  Объект 	- ОбъектСклонения 	- Ссылка на объект, реквизит которого склоняется.
//
// Возвращаемое значение:
//  Строка - Результат склонения представления объекта в падеже.
//
Функция ПросклонятьПредставление(Представление, Падеж, Объект = Неопределено) Экспорт
	
	Возврат Просклонять(Представление, Падеж, Объект);
	
КонецФункции

// Выполняет с формой действия, необходимые для подключения подсистемы Склонения.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для подключения механизма склонения.
//  Представление - Строка - Строка для склонения.
//  ИмяОсновногоРеквизитаФормы - Строка - Имя основного реквизита формы. 
//
Процедура ПриСозданииНаСервере(Форма, Представление, ИмяОсновногоРеквизитаФормы = "Объект") Экспорт

	МассивРеквизитов = Новый Массив;
	
	ЗаголовокРеквизита = НСтр("ru = 'Изменено представление'");
	РеквизитИзмененоПредставление = Новый РеквизитФормы("ИзмененоПредставление", Новый ОписаниеТипов("Булево"), , ЗаголовокРеквизита);
	МассивРеквизитов.Добавить(РеквизитИзмененоПредставление);
	
	РеквизитСклонения = Новый РеквизитФормы("Склонения", Новый ОписаниеТипов(), , "Склонения");
	МассивРеквизитов.Добавить(РеквизитСклонения);
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	СтруктураСклонения = СклоненияИзРегистра(Представление, Форма[ИмяОсновногоРеквизитаФормы].Ссылка);
	Если СтруктураСклонения <> Неопределено Тогда
		Форма.Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонения);
	КонецЕсли;
		
КонецПроцедуры

// Обработчик события ПриЗаписиНаСервере управляемой формы объекта для склонения.
//
// Параметры:
//  Форма 			- УправляемаяФорма - форма объекта склонения.
//  Представление   - Строка - Строка для склонения.
//  Объект 			- ОбъектСклонения - Объект для склонения.
//  ЭтоФИО       	- Булево - Признак склонения ФИО.
//	Пол				- Число	- Пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//
Процедура ПриЗаписиНаСервере(Форма, Представление, Объект, ЭтоФИО = Ложь, Пол = Неопределено) Экспорт

	Если Форма.ИзмененоПредставление Тогда
		СтруктураСклонений = ПросклонятьПредставлениеПоВсемПадежам(Представление, ЭтоФИО, Пол);
		Форма.Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонений);
		Форма.ИзмененоПредставление = Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Форма.Склонения) = Тип("ФиксированнаяСтруктура") Тогда
		ЗаписатьВРегистрСклонения(Представление, Объект, Форма.Склонения);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак доступности сервиса склонения.
//
// Параметры:
//  Доступность	- Булево - Признак доступности сервиса склонения.
//
Процедура УстановитьДоступностьСервисаСклонения(Доступность) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущиеПараметры = Новый Соответствие(ПараметрыСеанса.ПараметрыКлиентаНаСервере);
	
	ТекущиеПараметры.Вставить("ДоступенСервисСклонения", Доступность);
	
	ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ТекущиеПараметры);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Склоняет переданную фразу.
// Только для работы на ОС Windows.
//
// Параметры:
//  ФИО   - Строка - фамилия, имя и отчество в именительном падеже, 
//                   которые необходимо просклонять.
//  Падеж - Число  - падеж, в который необходимо поставить ФИО:
//                   1 - Именительный.
//                   2 - Родительный.
//                   3 - Дательный.
//                   4 - Винительный.
//                   5 - Творительный.
//                   6 - Предложный.
//  Результат - Строка - в этот параметр помещается результат склонения.
//                       Если ФИО не удалось просклонять, то возвращается значение ФИО.
//  Пол       - Число - пол физического лица, 1 - мужской, 2 - женский.
//
// Возвращаемое значение:
//   Булево - Истина, если ФИО удалось просклонять.
//
Функция ПросклонятьФИОСПомощьюКомпоненты(Знач ФИО, Падеж, Результат, Пол = Неопределено) Экспорт
	
	ПроверитьПараметрПолМетодаПросклонятьФИО(Пол);	
	
	Компонента = ОбщегоНазначения.ПодключитьКомпонентуИзМакета("CNameDecl", "ОбщийМакет.КомпонентаСклоненияФИО");
	
	Если Компонента = Неопределено Тогда 
		Результат = ФИО;
		Возврат Ложь;
	КонецЕсли;
	
	Результат = "";
	
	МассивСтрок = СтрРазделить(ФИО, " ", Ложь);
	
	// Выделим первые 3 слова, так как компонента не умеет склонять фразу большую 3х символов.
	НомерНесклоняемогоСимвола = 4;
	Для Номер = 1 По Мин(МассивСтрок.Количество(), 3) Цикл
		Если Не ФизическиеЛицаКлиентСервер.ФИОНаписаноВерно(МассивСтрок[Номер-1], Истина) Тогда
			НомерНесклоняемогоСимвола = Номер;
			Прервать;
		КонецЕсли;
		Результат = Результат + ?(Номер > 1, " ", "") + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = ФИО;
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Если Пол = Неопределено Тогда
			Результат = Компонента.Просклонять(Результат, Падеж) + " ";
		Иначе
			Результат = Компонента.Просклонять(Результат, Падеж, Пол) + " ";
		КонецЕсли;
	Исключение
		Событие = НСтр("ru = 'Склонение ФИО при помощи компоненты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(Событие, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки());
		Результат = ФИО;
		Возврат Ложь;
	КонецПопытки;
	
	// Остальные символы добавим без склонения.
	Для Номер = НомерНесклоняемогоСимвола По МассивСтрок.Количество() Цикл
		Результат = Результат + " " + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Результат = СокрЛП(Результат);
	
	Возврат Истина;
	
КонецФункции

// Определяет доступен ли сервис склонения.
// 
// Возвращаемое значение: 
//	Булево  - Истина, если веб-сервис склонения доступен.
//
Функция ДоступенСервисСклонения() Экспорт
	
	Результат = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ДоступенСервисСклонения");
	
	Если Результат = Неопределено Тогда
		Возврат Истина;
	Иначе 
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Склоняет переданную фразу по всем падежам.
//
// Параметры:
//  Представление   - Строка - Строка для склонения.
//  ЭтоФИО       	- Булево - Признак склонения ФИО.
//	Пол				- Число	- Пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//  ПоказыватьСообщения - Булево - Признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
// Возвращаемое значение:
//	 Структура - со свойствами:
//		*ИменительныйПадеж 	- Строка.
//		*РодительныйПадеж 	- Строка.
//		*ДательныйПадеж 	- Строка
//		*ВинительныйПадеж 	- Строка.
//		*ТворительныйПадеж 	- Строка.
//		*ПредложныйПадеж 	- Строка.
//
Функция ПросклонятьПредставлениеПоВсемПадежам(Представление, ЭтоФИО = Ложь, Пол = Неопределено, ПоказыватьСообщения = Ложь) Экспорт
	
	СтруктураСклонения = СклоненияИзРегистра(Представление);
		
	Если СтруктураСклонения <> Неопределено Тогда
		Возврат СтруктураСклонения;
	КонецЕсли;
	
	СтруктураСклонения = ДанныеСклонения(Представление, ЭтоФИО, Пол, ПоказыватьСообщения);
			
	Возврат СтруктураСклонения;
	
КонецФункции

// Получает данные склонения по всем падежам.
//
// Параметры:
//  Представление   - Строка - Строка для склонения.
//  ЭтоФИО       	- Булево - Признак склонения ФИО.
//	Пол				- Число	- Пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//  ПоказыватьСообщения - Булево - Признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
// Возвращаемое значение:
//	 Структура - со свойствами:
//		*ИменительныйПадеж 	- Строка.
//		*РодительныйПадеж 	- Строка.
//		*ДательныйПадеж 	- Строка
//		*ВинительныйПадеж 	- Строка.
//		*ТворительныйПадеж 	- Строка.
//		*ПредложныйПадеж 	- Строка.
//
Функция ДанныеСклонения(Представление, ЭтоФИО = Ложь, Пол = Неопределено, ПоказыватьСообщения = Ложь) Экспорт	
	
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Возврат СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
	КонецЕсли;
	
	ИспользоватьСервисСклонения = Константы.ИспользоватьСервисСклоненияMorpher.Получить();
	
	Если Не ЭтоФИО И ИспользоватьСервисСклонения Тогда
		
		СтруктураСклонения = СтруктураСклоненияЧерезЗапросКСервису(Представление, ПоказыватьСообщения);
		
		Если СтруктураСклонения <> Неопределено Тогда
			УстановитьДоступностьСервисаСклонения(Истина);
			Возврат СтруктураСклонения;
		Иначе
			УстановитьДоступностьСервисаСклонения(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураСклонения = Неопределено Тогда
		СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
	КонецЕсли;
	
	ПросклонятьСПомощьюКомпоненты = Ложь;
	
	Если ЭтоФИО Тогда
		ПросклонятьСПомощьюКомпоненты = Истина;	
	Иначе
		МассивСтрок = СтрРазделить(Представление, " ", Ложь);
		Если МассивСтрок.Количество() = 1 
			И СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(Представление) Тогда
			
			ПросклонятьСПомощьюКомпоненты = Истина;
		КонецЕсли;		
	КонецЕсли;	
			
	Если ПросклонятьСПомощьюКомпоненты Тогда
		ПросклонятьСПомощьюКомпоненты(Представление, СтруктураСклонения, , Пол);
	Иначе
		ЗаполнитьСтруктуруСклоненияПоПредставлению(СтруктураСклонения, Представление);					
	КонецЕсли;
			
	Возврат СтруктураСклонения;

КонецФункции

Процедура ПросклонятьПредставлениеПоВсемПадежамДлительнаяОперация(Параметры, АдресРезультата) Экспорт
	
	Если Параметры.ИзмененоПредставление Или Параметры.Склонения = Неопределено Тогда

		СтруктураСклонения = ПросклонятьПредставлениеПоВсемПадежам(Параметры.Представление, Параметры.ЭтоФИО, Параметры.Пол, Истина);
	
		ПоместитьВоВременноеХранилище(СтруктураСклонения, АдресРезультата);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Разрешения = Новый Массив();
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнейКомпоненты("ОбщийМакет.КомпонентаСклоненияФИО", 
		НСтр("ru = 'Для использования функций по склонению ФИО.'")));
	
	ЗапросыРазрешений.Добавить(
		МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения));
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Склоняет представление объекта.
// Только для работы на ОС Windows.
//
// Параметры:
// 	Объект	- ОбъектСклонения 	- Ссылка на объект, в котором содержится реквизит для склонения.
// 	ВидПредставления - Строка 	- Имя реквизита объекта для склонения.
// 	Падеж 	- Число  			- падеж, в который необходимо просклонять представление объекта.
//                  			1 - Именительный.
//                  			2 - Родительный.
//                  			3 - Дательный.
//                  			4 - Винительный.
//                  			5 - Творительный.
//                  			6 - Предложный.
//
// Возвращаемое значение:
//  	Строка - Результат склонения представления объекта в падеже.
//
Функция Просклонять(Представление, Падеж, Объект = Неопределено, ЭтоФИО = Ложь, Пол = Неопределено) 
	
	ПредставлениеВПадеже = "";
	
	СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
	
	СоответствиеПадежей = СоответствиеПадежей();
	
	ИмяПадежа = СоответствиеПадежей.Получить(Падеж);
	
	Если ИмяПадежа = Неопределено Тогда
		Возврат ПредставлениеВПадеже;
	КонецЕсли;
	
	// сначала получаем склонения из регистра СклоненияПредставленийОбъектов.
	СтруктураСклоненияИзРегистра = СклоненияИзРегистра(Представление, Объект);
		
	Если СтруктураСклоненияИзРегистра <> Неопределено И ЗначениеЗаполнено(СтруктураСклоненияИзРегистра[ИмяПадежа]) Тогда
		Возврат СтруктураСклоненияИзРегистра[ИмяПадежа];
	КонецЕсли;
	
	Если ЭтоФИО Тогда
		
		// Если склоняем ФИО, то используем компоненту склонения ФИО.
		ПросклонятьСПомощьюКомпоненты(Представление, СтруктураСклонения, , Пол);
						
		// Запись в регистр СклоненияПредставленийОбъектов успешного склонения.
		Если ЗначениеЗаполнено(Объект) Тогда
			ЗаписатьВРегистрСклонения(Представление, Объект, СтруктураСклонения);
		КонецЕсли;
		
		Возврат СтруктураСклонения[ИмяПадежа];
		
	КонецЕсли;

	// Если склоняем не ФИО, тогда обращаемся к веб-сервису, если разрешено и сервис доступен.
	ИспользоватьСервисСклонения = Константы.ИспользоватьСервисСклоненияMorpher.Получить();
	
	Если Не ИспользоватьСервисСклонения Тогда
		Возврат Представление;
	КонецЕсли;
	
	СтруктураСклонения = СтруктураСклоненияЧерезЗапросКСервису(Представление, Ложь);
	
	Если СтруктураСклонения = Неопределено Тогда
		
		УстановитьДоступностьСервисаСклонения(Ложь);
		Возврат Представление;
		
	КонецЕсли;
		
	УстановитьДоступностьСервисаСклонения(Истина);
	
	// Запись в регистр СклоненияПредставленийОбъектов успешного склонения.
	Если ЗначениеЗаполнено(Объект) Тогда
		ЗаписатьВРегистрСклонения(Представление, Объект, СтруктураСклонения);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтруктураСклонения[ИмяПадежа]) Тогда
		Возврат Представление;
	КонецЕсли;   
	
	Возврат СтруктураСклонения[ИмяПадежа];
			
КонецФункции

Процедура ЗаписатьВРегистрСклонения(Представление, Объект, Склонения) 
	
	Если Не Метаданные.ОпределяемыеТипы.ОбъектСклонения.Тип.СодержитТип(ТипЗнч(Объект)) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ХешПредставления = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Представление);
	
	НаборЗаписейСклонения = РегистрыСведений.СклоненияПредставленийОбъектов.СоздатьНаборЗаписей();
		
	НаборЗаписейСклонения.Отбор.Объект.Установить(Объект.Ссылка);
		
	НоваяСтрока = НаборЗаписейСклонения.Добавить();
		
	НоваяСтрока.Объект = Объект.Ссылка;
	НоваяСтрока.ХешПредставления = ХешПредставления;
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Склонения);
	
	НаборЗаписейСклонения.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция СтруктураСклоненияЧерезЗапросКСервису(Представление, ПоказыватьСообщения) 
	
	СообщениеОбОшибке = "";
	
	СтруктураСклонения = Неопределено;
	
	Результат = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	Логин = Константы.ЛогинДоступаКСервисуMorpher.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Результат = РезультатОбращенияКСервису("http://morpher.ru/WebService.asmx?WSDL", Представление, Логин, СообщениеОбОшибке);	
	
	Если Результат = Неопределено Тогда
		
		Результат = РезультатОбращенияКСервису("http://morphapi.ru/WebService.asmx?WSDL", Представление, Логин, СообщениеОбОшибке);	
		
	КонецЕсли;
		
	Если Результат <> Неопределено Тогда
			
		СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
		
		СтруктураСклонения.ИменительныйПадеж 	= Представление;
		СтруктураСклонения.РодительныйПадеж 	= Результат.Р;
		СтруктураСклонения.ДательныйПадеж 		= Результат.Д;
		СтруктураСклонения.ВинительныйПадеж 	= Результат.В;
		СтруктураСклонения.ТворительныйПадеж 	= Результат.Т;
		СтруктураСклонения.ПредложныйПадеж 		= Результат.П;
		
		Если Не ПустаяСтрока(СообщениеОбОшибке) Тогда
			КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Вызов веб-сервиса склонения'", КодОсновногоЯзыка), УровеньЖурналаРегистрации.Предупреждение, , ,СообщениеОбОшибке);
		КонецЕсли;	
		
	Иначе
		
		КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Вызов веб-сервиса склонения'", КодОсновногоЯзыка), УровеньЖурналаРегистрации.Ошибка, , ,СообщениеОбОшибке);
		
		Если ПоказыватьСообщения Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Ошибка при вызове сервиса склонения. Обратитесь к администратору.'") + Символы.ПС + НСтр("ru = 'Техническая информация:'") + Символы.ПС + СообщениеОбОшибке);
		КонецЕсли;
					
	КонецЕсли;		
	
	Возврат СтруктураСклонения;
	                                       	
КонецФункции

Функция РезультатОбращенияКСервису(URL, Представление, Логин, СообщениеОбОшибке)
	
	Результат = Неопределено;
	
	ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = URL;
	ПараметрыПодключения.URIПространстваИмен = "http://morpher.ru/";
	ПараметрыПодключения.ИмяСервиса = "WebService";
	ПараметрыПодключения.Таймаут = 10;
	
	Попытка
		
		Если ЗначениеЗаполнено(Логин) Тогда
			Пароль = "";
			
			УстановитьПривилегированныйРежим(Истина);
			Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.СклоненияПредставленийОбъектов"), "ПарольДоступаКСервисуMorpher"); 
			УстановитьПривилегированныйРежим(Ложь);
			
			ПараметрыПодключения.ИмяПользователя = Логин;
			ПараметрыПодключения.Пароль = Пароль;
		КонецЕсли;
		
		Морфер = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
		Результат = Морфер.GetXml(Представление);
		
	Исключение
		
		Если НЕ ПустаяСтрока(СообщениеОбОшибке) Тогда	
			СообщениеОбОшибке = СообщениеОбОшибке + Символы.ПС;
		КонецЕсли;
		
		СообщениеОбОшибке = СообщениеОбОшибке + URL + Символы.ПС + ОписаниеОшибки();
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция СклоненияИзРегистра(Представление, Объект = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);

	СтруктураСклонения = Неопределено;
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ВЫРАЗИТЬ(СклоненияПредставленийОбъектов.ИменительныйПадеж КАК СТРОКА(255))) КАК КоличествоНаборовСклонений,
	|	СклоненияПредставленийОбъектов.ХешПредставления
	|ПОМЕСТИТЬ ТаблицаРегистраБезОтбораПоОбъекту
	|ИЗ
	|	РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
	|ГДЕ
	|	СклоненияПредставленийОбъектов.ХешПредставления = &ХешПредставления
	|
	|СГРУППИРОВАТЬ ПО
	|	СклоненияПредставленийОбъектов.ХешПредставления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СклоненияПредставленийОбъектов.ИменительныйПадеж,
	|	СклоненияПредставленийОбъектов.РодительныйПадеж,
	|	СклоненияПредставленийОбъектов.ДательныйПадеж,
	|	СклоненияПредставленийОбъектов.ВинительныйПадеж,
	|	СклоненияПредставленийОбъектов.ТворительныйПадеж,
	|	СклоненияПредставленийОбъектов.ПредложныйПадеж,
	|	0 КАК Приоритет
	|ИЗ
	|	РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
	|ГДЕ
	|	&ИспользуетсяОтборПоОбъекту
	|	И СклоненияПредставленийОбъектов.Объект = &Объект
	|	И СклоненияПредставленийОбъектов.ХешПредставления = &ХешПредставления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СклоненияПредставленийОбъектов.ИменительныйПадеж,
	|	СклоненияПредставленийОбъектов.РодительныйПадеж,
	|	СклоненияПредставленийОбъектов.ДательныйПадеж,
	|	СклоненияПредставленийОбъектов.ВинительныйПадеж,
	|	СклоненияПредставленийОбъектов.ТворительныйПадеж,
	|	СклоненияПредставленийОбъектов.ПредложныйПадеж,
	|	1
	|ИЗ
	|	РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаРегистраБезОтбораПоОбъекту КАК ТаблицаРегистраБезОтбораПоОбъекту
	|		ПО СклоненияПредставленийОбъектов.ХешПредставления = ТаблицаРегистраБезОтбораПоОбъекту.ХешПредставления
	|			И (ТаблицаРегистраБезОтбораПоОбъекту.КоличествоНаборовСклонений = 1)
	|ГДЕ
	|	СклоненияПредставленийОбъектов.ХешПредставления = &ХешПредставления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Запрос.УстановитьПараметр("ХешПредставления", ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Представление));
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("ИспользуетсяОтборПоОбъекту", ЗначениеЗаполнено(Объект));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
		ЗаполнитьЗначенияСвойств(СтруктураСклонения, Выборка);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);

	Возврат СтруктураСклонения;		
	
КонецФункции

Процедура ПросклонятьСПомощьюКомпоненты(Представление, СтруктураСклонения, Падеж = 0, Пол = Неопределено)
	
	СоответствиеПадежей = СоответствиеПадежей();

	Если Падеж = 0 Тогда
		СтруктураСклонения.ИменительныйПадеж = Представление;
		
		Для НомерПадежа = 2 По 6 Цикл
		
			ПросклонятьФИОСПомощьюКомпоненты(Представление, НомерПадежа, СтруктураСклонения[СоответствиеПадежей.Получить(НомерПадежа)], Пол);
			
		КонецЦикла;
		
	Иначе
		
		ИмяПадежа = СоответствиеПадежей.Получить(Падеж);
		Если ИмяПадежа <> Неопределено Тогда
			ПросклонятьФИОСПомощьюКомпоненты(Представление, Падеж, СтруктураСклонения[ИмяПадежа], Пол);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СоответствиеПадежей()
	
	СоответствиеПадежей = Новый Соответствие;
	
	СоответствиеПадежей.Вставить(1, "ИменительныйПадеж");
	СоответствиеПадежей.Вставить(2, "РодительныйПадеж");
	СоответствиеПадежей.Вставить(3, "ДательныйПадеж");
	СоответствиеПадежей.Вставить(4, "ВинительныйПадеж");
	СоответствиеПадежей.Вставить(5, "ТворительныйПадеж");
	СоответствиеПадежей.Вставить(6, "ПредложныйПадеж");
	
	Возврат СоответствиеПадежей;
	
КонецФункции

Процедура ЗаполнитьСтруктуруСклоненияПоПредставлению(СтруктураСклонения, Представление)
	
	Для Каждого КлючИЗначение Из СтруктураСклонения Цикл
		СтруктураСклонения.Вставить(КлючИЗначение.Ключ, Представление);
	КонецЦикла;
	                                                     
КонецПроцедуры

Функция ЕстьПравоДоступаКОбъекту(Ссылка) Экспорт
	
	Возврат ПравоДоступа("Редактирование", Ссылка.Метаданные());
	
КонецФункции

Процедура ПроверитьПараметрПолМетодаПросклонятьФИО(Пол)
	
	Если Пол = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"СклонениеПредставленийОбъектов.ПросклонятьФИО", "Пол", Пол, Тип("Число"));
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недопустимое значение параметра %1 в %2.
		           |параметр должен числом 1 (мужской) или 2 (женский); передано значение: %3 (тип %4).'"),
		"Пол", "СклонениеПредставленийОбъектов.ПросклонятьФИО", Пол, ТипЗнч(Пол));
	ОбщегоНазначенияКлиентСервер.Проверить(Пол = 1 Или Пол = 2, ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти