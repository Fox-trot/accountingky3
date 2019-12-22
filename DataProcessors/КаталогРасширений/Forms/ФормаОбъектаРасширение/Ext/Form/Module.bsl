﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.ИдентификаторВерсии) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры.НаименованиеРасширения;
	
	АдресХранилищаРезультат = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	АдресХранилищаОценки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ЗагрузкаДанных;
	
	Если НЕ КаталогРасширений.ПолучитьДанныеВерсииРасширенияВФоне(АдресХранилищаРезультат, Параметры.ИдентификаторВерсии, ПолучитьНавигационнуюСсылкуИнформационнойБазы()) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось отправить запрос в МС.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	КартинкаДлительная85 = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.КаталогРасширенийДлительнаяОперация85, УникальныйИдентификатор);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчик();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерСкриншотаПриИзменении(Элемент)
	
	АдресСкриншота = ТаблицаСкриншотов[НомерСкриншота].АдресВХранилище;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресСкриншотаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыНовойФормы = Новый Структура("АдресИзображения", АдресСкриншота);
	ОткрытьФорму("Обработка.КаталогРасширений.Форма.ФормаПросмотраИзображений", ПараметрыНовойФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресИнформацииОПоставщикеНажатие(Элемент)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресИнформацииОПоставщике);
КонецПроцедуры

&НаКлиенте
Процедура АдресИнформацииОКонфигурацииНажатие(Элемент)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресИнформацииОКонфигурации);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОценокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = ТаблицаОценок.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ПараметрыНовойФормы = Новый Структура;	
	ПараметрыНовойФормы.Вставить("Отзыв", ДанныеСтроки.Отзыв);
	ПараметрыНовойФормы.Вставить("Оценка", ДанныеСтроки.Оценка);
	ПараметрыНовойФормы.Вставить("ДатаРедактирования", ДанныеСтроки.ДатаПоследнегоИзменения);
	ПараметрыНовойФормы.Вставить("Версия", ДанныеСтроки.Версия);
	ПараметрыНовойФормы.Вставить("Автор", ДанныеСтроки.Автор);
	ПараметрыНовойФормы.Вставить("Наименование", ДанныеСтроки.Наименование);	
		
	ОткрытьФорму("Обработка.КаталогРасширений.Форма.ФормаОценки", 
		Новый Структура("ДанныеЗаполнения", ПараметрыНовойФормы), 
		ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеОценокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Оценка_Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Тек_Оценка = Число(СтрЗаменить(Элемент.Имя, "ПиктограммаОценка_", ""));
	ОтобразитьИнформациюОбОценке();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	Если ЗапретДействия Тогда
		Возврат;
	КонецЕсли;
	
	ПодтверждениеЗавершенияСеансовПолучено = Ложь;
	
	Если Состояние = "Установлено" ИЛИ Состояние = "Ошибка удаления" Тогда
		
		ЗаголовокВопроса = НСтр("ru = 'Удаление расширения'");
		ПервоеСлово = НСтр("ru = 'Удалить'");
		ЭтоУстановка = Ложь;
		
	Иначе
		
		ЗаголовокВопроса = НСтр("ru = 'Установка расширения'");
		ПервоеСлово = НСтр("ru = 'Установить'");
		ЭтоУстановка = Истина;
		
	КонецЕсли;
	
	ЗапретДействия = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОтветДействие", ЭтотОбъект, ЭтоУстановка);
	ТекстВопроса = СтрШаблон(НСтр("ru = '%1 расширение ""%2""?'"), ПервоеСлово, НаименованиеРасширения);
	
	Если ЗначениеЗаполнено(ДополнительныйТекстПриУстановке) И ЭтоУстановка Тогда
		
		МассивСтрок = Новый Массив;
		
		СтрокаЗвездочка = Новый ФорматированнаяСтрока("*", Новый Шрифт(, 15, Истина), Новый Цвет(255, 0, 0));
		МассивСтрок.Добавить(СтрокаЗвездочка);
		МассивСтрок.Добавить(ДополнительныйТекстПриУстановке + Символы.ПС);
		МассивСтрок.Добавить(ТекстВопроса);
		
		ТекстВопроса = Новый ФорматированнаяСтрока(МассивСтрок);	
		
	КонецЕсли;
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,, ЗаголовокВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьОтзыв(Команда)
	
	НайденныеСтроки = ТаблицаОценок.НайтиСтроки(Новый Структура("ОценкаТекущегоПользователя", Истина));
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;			
	КонецЕсли;
	
	ОткрытьОценку(НайденныеСтроки[0], Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Оценить(Команда)
	
	Если Тек_Оценка = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите оценку'"),, "ПиктограммаОценка_3");	
		Возврат;	
	КонецЕсли;
	
	Если Элементы.ОценитьРасширение.Картинка <> Новый Картинка Тогда
		Возврат;		
	КонецЕсли;
	
	Если ИзменитьДанныеОценкиВМС() Тогда
		ИзменитьДоступностьПолейОценки(Ложь);
		ПодключитьОбработчик();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОтзыв(Команда)
	
	Если Элементы.УдалитьОтзыв.Картинка <> Новый Картинка Тогда
		Возврат;		
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ОбработатьОтветУдалениеОтзыва", ЭтотОбъект);
	ПоказатьВопрос(Описание, НСтр("ru = 'Удалить вашу оценку и отзыв?'"), РежимДиалогаВопрос.ДаНет,,, НСтр("ru = 'Удаление оценки'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьРезультатВыполненияЗапросаКМС()
	
	ДанныеРезультат = ПолучитьИзВременногоХранилища(АдресХранилищаРезультат);
	ДанныеОценки = ПолучитьИзВременногоХранилища(АдресХранилищаОценки);
	
	ЭтоРезультат = Ложь;
	ЭтоОценка = Ложь;
	
	Если ДанныеРезультат <> Неопределено Тогда
		ДанныеХранилища = ДанныеРезультат;
		ЭтоРезультат = Истина;
	ИначеЕсли ДанныеОценки <> Неопределено Тогда
		ДанныеХранилища = ДанныеОценки;
		ЭтоОценка = Истина;
	Иначе
		Возврат;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("ОбработатьРезультатВыполненияЗапросаКМС");
	
	Если НЕ ДанныеХранилища.success Тогда
		ОтобразитьИнформациюОбОшибке(ДанныеХранилища);
		Возврат;
	КонецЕсли;
	
	Если ДанныеХранилища.ИмяМетода = "ПолучитьДанныеВерсииРасширения" Тогда
		ОтобразитьИнформациюОВерсииРасширенияНаСервере(ДанныеХранилища);
		ОбработатьИзменениеСостоянияРасширения();
		ОтобразитьИнформациюОбОценке();
	ИначеЕсли ДанныеХранилища.ИмяМетода = "ПолучитьСтатусРасширения" 
			ИЛИ ДанныеХранилища.ИмяМетода = "НачатьУстановкуРасширения"
			ИЛИ ДанныеХранилища.ИмяМетода = "НачатьУдалениеРасширения" Тогда 
		ОтобразитьНовыйСтатусРасширения(ДанныеХранилища);
	ИначеЕсли ДанныеХранилища.ИмяМетода = "ИзменитьОценкуПользователя" Тогда
		Тек_ДатаРедактирования = ПолучитьТекущуюДату();
		ИзменитьДоступностьПолейОценки(Истина);
	ИначеЕсли ДанныеХранилища.ИмяМетода = "УдалитьОценкуПользователя" Тогда
		ОбработатьУдалениеОценки();
	КонецЕсли;
	
	Если ЭтоРезультат Тогда
		ПоместитьВоВременноеХранилище(Неопределено, АдресХранилищаРезультат);	
	КонецЕсли;
	
	Если ЭтоОценка Тогда
		ПоместитьВоВременноеХранилище(Неопределено, АдресХранилищаОценки);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьИнформациюОВерсииРасширенияНаСервере(ДанныеХранилища)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ДанныеРасширения;	
	
	ЕстьПравоНаУстановку 	= ДанныеХранилища.result.ЕстьПравоНаУстановку;	
	ИнформацияОРасширении 	= ДанныеХранилища.result.ДанныеРасширения;
	
	АвторскиеПрава 					= ИнформацияОРасширении.АвторскиеПрава;
	АдресИнформацииОПоставщике 		= ИнформацияОРасширении.АдресИнформацииОПоставщике;
	АдресИнформацииОКонфигурации 	= ИнформацияОРасширении.АдресИнформацииОКонфигурации;
	ИдентификаторВерсии 			= ИнформацияОРасширении.ИдентификаторВерсии;
	ИдентификаторРасширения 		= ИнформацияОРасширении.ИдентификаторРасширения;
	КраткаяИнформация 				= ИнформацияОРасширении.КраткаяИнформация;
	НаименованиеВерсии 				= ИнформацияОРасширении.НаименованиеВерсии;
	НаименованиеРасширения 			= ИнформацияОРасширении.НаименованиеРасширения;
	ПодробнаяИнформация 			= ИнформацияОРасширении.ПодробнаяИнформация;
	Состояние 						= ИнформацияОРасширении.Состояние;
	Установлено 					= ИнформацияОРасширении.Установлено;
	ДатаОбновления					= ИнформацияОРасширении.ДатаСоздания;
	Разработчик						= ИнформацияОРасширении.Разработчик;
	Отключено						= ИнформацияОРасширении.Отключено;
	ИнформацияОСостоянии			= ИнформацияОРасширении.ИнформацияОСостоянии;
	СостояниеРасширения				= ИнформацияОРасширении.СостояниеРасширения;
	ИзменяетСтруктуруДанных			= ИнформацияОРасширении.ИзменяетСтруктуруДанных;
	АдресМС							= ИнформацияОРасширении.АдресМС;
	
	Превью = ПоместитьВоВременноеХранилище(Base64Значение(ИнформацияОРасширении.Превью), УникальныйИдентификатор);	
	
	Для Каждого ДанныеСкриншота Из ИнформацияОРасширении.Скриншоты Цикл
		
		НоваяСтрока = ТаблицаСкриншотов.Добавить();
		НоваяСтрока.ИмяФайла = ДанныеСкриншота.Наименование;
		НоваяСтрока.АдресВХранилище = ПоместитьВоВременноеХранилище(Base64Значение(ДанныеСкриншота.Данные), УникальныйИдентификатор);
		
		Элементы.НомерСкриншота.СписокВыбора.Добавить(ТаблицаСкриншотов.Индекс(НоваяСтрока), " ");
		
	КонецЦикла;
	
	Если ТаблицаСкриншотов.Количество() = 0 Тогда
		Элементы.ГруппаСкриншоты.Видимость = Ложь;
	Иначе
		АдресСкриншота = ТаблицаСкриншотов[0].АдресВХранилище;
	КонецЕсли;
	
	ИнформацияОРасширении.Свойство("ВариантУстановки", ВариантУстановки);
	ИнформацияОРасширении.Свойство("ДополнительныйТекстПриУстановке", ДополнительныйТекстПриУстановке);
	
	Элементы.АвторскиеПрава.Видимость = ЗначениеЗаполнено(АвторскиеПрава);
	Элементы.АдресИнформацииОПоставщике.Видимость = ЗначениеЗаполнено(АдресИнформацииОПоставщике);
	Элементы.АдресИнформацииОКонфигурации.Видимость = ЗначениеЗаполнено(АдресИнформацииОКонфигурации);
	
	Элементы.АдресИнформацииОПоставщике.Подсказка = СтрШаблон(Элементы.АдресИнформацииОПоставщике.Подсказка, АдресИнформацииОПоставщике);
	Элементы.АдресИнформацииОКонфигурации.Подсказка = СтрШаблон(Элементы.АдресИнформацииОКонфигурации.Подсказка, АдресИнформацииОКонфигурации);
	
	Элементы.ПодробноеОписание.Видимость = ЗначениеЗаполнено(ПодробнаяИнформация);	
	Элементы.НомерСкриншота.Видимость = ТаблицаСкриншотов.Количество() > 1;
	
	Элементы.ГруппаРасширениеОтключено.Видимость = Отключено;
	
	ОтобразитьДанныеОценокИОтзывов(ИнформацияОРасширении);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеСостоянияРасширения()
	
	Если НЕ ЕстьПравоНаУстановку Тогда
		Элементы.ВыполнитьДействие.Видимость = Ложь;
		Элементы.ВыполнитьДействие.Заголовок = Состояние;
		Возврат;
	КонецЕсли;
	
	Если Состояние = "Установлено" ИЛИ Состояние = "Ошибка удаления" Тогда
		
		Элементы.ВыполнитьДействие.Заголовок = НСтр("ru = 'Удалить'");
		Элементы.ВыполнитьДействие.ЦветФона = Новый Цвет(255, 255, 255);
		Элементы.ВыполнитьДействие.Отображение = ОтображениеКнопки.Текст;
		
	ИначеЕсли Состояние = "Устанавливается" ИЛИ Состояние = "Удаляется" Тогда
		
		ЗапретДействия = Истина;
		Элементы.ВыполнитьДействие.Заголовок = Состояние;
		Элементы.ВыполнитьДействие.ЦветФона = Новый Цвет(255, 255, 255);
		Элементы.ВыполнитьДействие.Отображение = ОтображениеКнопки.КартинкаИТекст;
		
	ИначеЕсли Состояние = "Ошибка установки" ИЛИ Состояние = "Не установлено" Тогда
		
		Элементы.ВыполнитьДействие.Заголовок = ?(ЗначениеЗаполнено(ВариантУстановки), ВариантУстановки, НСтр("ru = 'Установить'"));
		Элементы.ВыполнитьДействие.ЦветФона = Новый Цвет(255, 225, 0);
		Элементы.ВыполнитьДействие.Отображение = ОтображениеКнопки.Текст;
		
	КонецЕсли;
			
	Если Состояние = "Устанавливается" ИЛИ Состояние = "Удаляется" Тогда
		НачатьОбновлениеСостояния();
		Элементы.ВыполнитьДействие.Отображение = ОтображениеКнопки.КартинкаИТекст;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветДействие(Ответ, ЭтоУстановка) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		ЗапретДействия = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ИзменяетСтруктуруДанных И НЕ ПодтверждениеЗавершенияСеансовПолучено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОтветДействие", ЭтотОбъект, ЭтоУстановка);
		
		Если ЭтоУстановка Тогда
			ПервоеСклонение = НСтр("ru = 'установки'");
			ВтороеСклонение = НСтр("ru = 'установкой'");
			ТретьеСклонение = НСтр("ru = 'установку'");
		Иначе	
			ПервоеСклонение = НСтр("ru = 'удаления'");
			ВтороеСклонение = НСтр("ru = 'удалением'");
			ТретьеСклонение = НСтр("ru = 'удаление'");
		КонецЕсли;
		
		СтрокаОтступа = "	• ";
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru = 'Данное расширение изменяет структуру данных конфигурации, поэтому для %1 расширения требуется монопольный доступ к приложению:'") + Символы.ПС);
		МассивСтрок.Добавить(СтрокаОтступа);
		МассивСтрок.Добавить(НСтр("ru = 'Во время %1 расширения работа с приложеним будет недоступна.'") + Символы.ПС);
		МассивСтрок.Добавить(СтрокаОтступа);
		МассивСтрок.Добавить(НСтр("ru = 'Перед %2 расширения будет завершена работа всех пользователей приложения.'") + Символы.ПС);
		МассивСтрок.Добавить(СтрокаОтступа);
		МассивСтрок.Добавить(НСтр("ru = 'Процесс %1 данного расширения может быть продолжительным.'") + Символы.ПС);
		МассивСтрок.Добавить(НСтр("ru = 'Продолжить %3 расширения?'"));

		Текст = СтрШаблон(СтрСоединить(МассивСтрок), ПервоеСклонение, ВтороеСклонение, ТретьеСклонение);	
		
		ПодтверждениеЗавершенияСеансовПолучено = Истина;
		ПоказатьВопрос(ОписаниеОповещения, Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		Возврат;
		
	КонецЕсли;

	Если ЭтоУстановка Тогда
		ЗапросОтправлен = УстановитьНаСервере(АдресХранилищаРезультат, ИдентификаторРасширения, НЕ ИзменяетСтруктуруДанных);
	Иначе
		ЗапросОтправлен = УдалитьНаСервере(АдресХранилищаРезультат, ИдентификаторРасширения, НЕ ИзменяетСтруктуруДанных);	
	КонецЕсли;
	
	Если ЗапросОтправлен И НЕ ИзменяетСтруктуруДанных Тогда
		ПодключитьОбработчик();
	ИначеЕсли ЗапросОтправлен И ИзменяетСтруктуруДанных Тогда
		
		Если НЕ ПустаяСтрока(АдресМС) Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницыОжидания());
		КонецЕсли;
		
		ЗавершитьРаботуСистемы(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция АдресСтраницыОжидания()
	
	Возврат АдресМС + "/" + Формат(ЗначениеРазделителяСеанса(), "ЧГ=");
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеРазделителяСеанса()
	
	Возврат РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьНовыйСтатусРасширения(ДанныеХранилища)
	
	ЗапретДействия = Ложь;
	
	Состояние = ДанныеХранилища.result.СостояниеУстановки;
	Установлено = ДанныеХранилища.result.Установлено;
	
	СобытиеОповещения = "КаталогРасширений_ИзменениеСостояния";
	ПараметрыОповещения = Новый Структура("ИдентификаторРасширения, Состояние", ИдентификаторРасширения, Состояние);
	Оповестить(СобытиеОповещения, ПараметрыОповещения); 
	
	ОбработатьИзменениеСостоянияРасширения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьИнформациюОбОшибке(ДанныеХранилища)
	
	КодОшибки = ДанныеХранилища.error.code;
	ТекстОшибки = ДанныеХранилища.error.msg;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.Ошибка;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеСостояния()
	
	Если Состояние = "Устанавливается" Тогда
		Текст = НСтр("ru = 'Установка ...'");			
		Пояснение = НСтр("ru = 'Происходит установка расширения'");
	ИначеЕсли Состояние = "Удаляется" Тогда
		Текст = НСтр("ru = 'Удаление ...'");			
		Пояснение = НСтр("ru = 'Происходит удаление расширения'");
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(Текст,, Пояснение, БиблиотекаКартинок.Информация,, "ОбновлениеСтатуса");
	
	Если НЕ ОбновитьСостояниеНаСервере(АдресХранилищаРезультат, ИдентификаторРасширения) Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчик();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчик()
	ПодключитьОбработчикОжидания("ОбработатьРезультатВыполненияЗапросаКМС", 1);	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УдалитьНаСервере(АдресХранилищаРезультат, ИдентификаторРасширения, ВыполнятьВФоне)
	
	АдресХранилищаРезультат = ПоместитьВоВременноеХранилище(Неопределено, АдресХранилищаРезультат);
	
	КаталогРасширений.УстановитьОповещение(ИдентификаторРасширения, Пользователи.ТекущийПользователь(), Перечисления.СостоянияРасширений.Удаляется);
	
	Возврат КаталогРасширений.НачатьУдалениеРасширенияВФоне(АдресХранилищаРезультат, ИдентификаторРасширения, ВыполнятьВФоне);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОбновитьСостояниеНаСервере(АдресХранилищаРезультат, Знач ИдентификаторРасширения)
	
	АдресХранилищаРезультат = ПоместитьВоВременноеХранилище(Неопределено, АдресХранилищаРезультат);
	Возврат КаталогРасширений.ПолучитьСтатусРасширенияВФоне(АдресХранилищаРезультат, ИдентификаторРасширения);

КонецФункции

&НаСервереБезКонтекста
Функция УстановитьНаСервере(АдресХранилищаРезультат, ИдентификаторРасширения, ВыполнятьВФоне)
	
	АдресХранилищаРезультат = ПоместитьВоВременноеХранилище(Неопределено, АдресХранилищаРезультат);
	
	КаталогРасширений.УстановитьОповещение(ИдентификаторРасширения, Пользователи.ТекущийПользователь(), Перечисления.СостоянияРасширений.Устанавливается);
	
	Возврат КаталогРасширений.НачатьУстановкуРасширенияВФоне(АдресХранилищаРезультат, ИдентификаторРасширения, ВыполнятьВФоне);
	
КонецФункции

&НаСервере
Функция ПолучитьКартинкуОценки(УсредненнаяОценка)
	
	Если УсредненнаяОценка = 0 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_0;
	ИначеЕсли УсредненнаяОценка = 0.5 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_0_5;
	ИначеЕсли УсредненнаяОценка = 1 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_1;
	ИначеЕсли УсредненнаяОценка = 1.5 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_1_5;
	ИначеЕсли УсредненнаяОценка = 2 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_2;
	ИначеЕсли УсредненнаяОценка = 2.5 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_2_5;
	ИначеЕсли УсредненнаяОценка = 3 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_3;
	ИначеЕсли УсредненнаяОценка = 3.5 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_3_5;
	ИначеЕсли УсредненнаяОценка = 4 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_4;
	ИначеЕсли УсредненнаяОценка = 4.5 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_4_5
	ИначеЕсли УсредненнаяОценка = 5 Тогда
		КартинкаОценки = БиблиотекаКартинок.Оценка_5;
	Иначе
		КартинкаОценки = БиблиотекаКартинок.Оценка_0;
	КонецЕсли; 
	
	Возврат КартинкаОценки;
	
КонецФункции

&НаСервере
Процедура УстановитьКартинкуСтроки(НоваяСтрока)
	
	НоваяСтрока.Оценка_1 = ?(НоваяСтрока.Оценка >= 1, 0, 2); 
	НоваяСтрока.Оценка_2 = ?(НоваяСтрока.Оценка >= 2, 0, 2); 
	НоваяСтрока.Оценка_3 = ?(НоваяСтрока.Оценка >= 3, 0, 2); 
	НоваяСтрока.Оценка_4 = ?(НоваяСтрока.Оценка >= 4, 0, 2); 
	НоваяСтрока.Оценка_5 = ?(НоваяСтрока.Оценка >= 5, 0, 2); 
		
КонецПроцедуры

&НаСервере
Процедура УстановитьЧислоОценок(Точка, Серия, НомерОценки, Количество)
	
	Подсказка = СтрШаблон(НСтр("ru = 'Оценок %1: %2'"), НомерОценки, Количество);	
	РаспределениеОценок.УстановитьЗначение(Точка, Серия, Количество, НомерОценки, Подсказка);	
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДанныеОценокИОтзывов(ИнформацияОРасширении)
	
	КартинкаОценка = ПоместитьВоВременноеХранилище(ПолучитьКартинкуОценки(ИнформацияОРасширении.УсредненнаяОценка), УникальныйИдентификатор);
	
	Статистика_Оценка = ИнформацияОРасширении.Оценка;
	Статистика_ВсегоОценокИОтзывов = ИнформацияОРасширении.КоличествоОценок;
	Статистика_КоличествоУстановок = ИнформацияОРасширении.ПредставлениеУстановок;
	
	Точка = РаспределениеОценок.Точки[0];
	
	УстановитьЧислоОценок(Точка, РаспределениеОценок.Серии[0], 5, ИнформацияОРасширении.КоличествоОценок_5);
	УстановитьЧислоОценок(Точка, РаспределениеОценок.Серии[1], 4, ИнформацияОРасширении.КоличествоОценок_4);
	УстановитьЧислоОценок(Точка, РаспределениеОценок.Серии[2], 3, ИнформацияОРасширении.КоличествоОценок_3);
	УстановитьЧислоОценок(Точка, РаспределениеОценок.Серии[3], 2, ИнформацияОРасширении.КоличествоОценок_2);
	УстановитьЧислоОценок(Точка, РаспределениеОценок.Серии[4], 1, ИнформацияОРасширении.КоличествоОценок_1);
	
	Для Каждого ДанныеОценки Из ИнформацияОРасширении.Оценки Цикл
		
		НоваяСтрока = ТаблицаОценок.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеОценки);
		
		НоваяСтрока.ДатаПоследнегоИзменения = ПрочитатьДатуJSON(ДанныеОценки.ДатаПоследнегоИзменения, ФорматДатыJSON.ISO);
		УстановитьКартинкуСтроки(НоваяСтрока);
		
		Если НЕ ПустаяСтрока(НоваяСтрока.Версия) Тогда
			НоваяСтрока.ПредставлениеВерсии = СтрШаблон(НСтр("ru = 'Оценка для версии: %1'"), НоваяСтрока.Версия);
		Иначе
			НоваяСтрока.ПредставлениеВерсии = НСтр("ru = 'Оценка без указания версии'");
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаОценок.Сортировать("ДатаПоследнегоИзменения УБЫВ");
	
	Если ТаблицаОценок.Количество() = 0 Тогда
		Элементы.КолонкаРаспределениеОценок.Видимость = Ложь;	
	КонецЕсли;
	
	ОтобразитьИнформациюОТекущейОценке();
	
	Элементы.ТаблицаОценок.ОтборСтрок = Новый ФиксированнаяСтруктура("ОценкаТекущегоПользователя", Ложь);	
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьИнформациюОТекущейОценке()
	
	НайденныеСтроки = ТаблицаОценок.НайтиСтроки(Новый Структура("ОценкаТекущегоПользователя", Истина));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		Тек_ДатаРедактирования = НайденныеСтроки[0].ДатаПоследнегоИзменения;
		Тек_Заголовок = НайденныеСтроки[0].Наименование;
		Тек_Отзыв = НайденныеСтроки[0].Отзыв;
		Тек_Оценка = НайденныеСтроки[0].Оценка;
		
		Элементы.ОценитьРасширение.ЦветФона = Новый Цвет;
		
	Иначе
		Элементы.УдалитьОтзыв.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОценку(ДанныеСтроки, ТолькоПросмотр = Истина)
	
	ПараметрыНовойФормы = Новый Структура;
	ПараметрыНовойФормы.Вставить("Редактирование", НЕ ТолькоПросмотр);
	ПараметрыНовойФормы.Вставить("ИдентификаторРасширения", ИдентификаторРасширения);
	ПараметрыНовойФормы.Вставить("ИдентификаторыВерсийРасширений", ИдентификаторВерсии);
	
	Если ДанныеСтроки = Неопределено Тогда
		ПараметрыНовойФормы.Вставить("НовыйОтзыв", Истина);
	Иначе
		
		ПараметрыНовойФормы.Вставить("Отзыв", ДанныеСтроки.Отзыв);
		ПараметрыНовойФормы.Вставить("Оценка", ДанныеСтроки.Оценка);
		ПараметрыНовойФормы.Вставить("ДатаРедактирования", ДанныеСтроки.ДатаПоследнегоИзменения);
		ПараметрыНовойФормы.Вставить("Версия", ДанныеСтроки.Версия);
		ПараметрыНовойФормы.Вставить("Автор", ДанныеСтроки.Автор);
		ПараметрыНовойФормы.Вставить("Наименование", ДанныеСтроки.Наименование);
		
	КонецЕсли;
		
	ОткрытьФорму("Обработка.КаталогРасширений.Форма.ФормаОценки", 
		Новый Структура("ДанныеЗаполнения", ПараметрыНовойФормы), 
		ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОбработатьОтветУдалениеОтзыва(Ответ, ДопПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	
	
	Если ИзменитьДанныеОценкиВМС(Истина) Тогда
		ПодключитьОбработчик();
		ИзменитьДоступностьПолейОценки(Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьУдалениеОценки()
	
	Тек_ДатаРедактирования = Неопределено;
	Тек_Заголовок = "";
	Тек_Отзыв = "";
	Тек_Оценка = 0;
	
	ИзменитьДоступностьПолейОценки(Истина, Истина);	
	НайденныеСтроки = ТаблицаОценок.НайтиСтроки(Новый Структура("ОценкаТекущегоПользователя", Истина));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		ТаблицаОценок.Удалить(НайденныеСтроки[0]);	
	КонецЕсли;
	
	ОтобразитьИнформациюОбОценке();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДоступностьПолейОценки(Доступно = Истина, Удаление = Ложь)
	
	Если Доступно Тогда
		Картинка = Новый Картинка;
	Иначе
		Картинка = БиблиотекаКартинок.КаталогРасширенийДлительнаяОперация85;
	КонецЕсли;
	
	Если Удаление Тогда
		Элементы.УдалитьОтзыв.Картинка = Картинка;
		Элементы.ОценитьРасширение.Доступность = Доступно;
		
		Если Доступно Тогда
			Элементы.УдалитьОтзыв.Видимость = Ложь;
		КонецЕсли;
		
	Иначе
		Элементы.ОценитьРасширение.Картинка = Картинка;
		Элементы.УдалитьОтзыв.Доступность = Доступно;
		
		Если Доступно Тогда
			Элементы.УдалитьОтзыв.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Тек_Заголовок.Доступность = Доступно;
	Элементы.Тек_Отзыв.Доступность = Доступно;
	Элементы.ГруппаИконкиОценки.Доступность = Доступно;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьДанныеОценкиВМС(Удалить = Ложь)
	
	Возврат КаталогРасширений.ИзменитьОценкуПользователя(АдресХранилищаОценки, ИдентификаторРасширения, 
		ИдентификаторВерсии, Тек_Оценка, Тек_Отзыв, Тек_Заголовок, Удалить);
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьИнформациюОбОценке()
	
	ПиктограммаОценка_1 = ?(Тек_Оценка >= 1, 0, 2);
	ПиктограммаОценка_2 = ?(Тек_Оценка >= 2, 0, 2);
	ПиктограммаОценка_3 = ?(Тек_Оценка >= 3, 0, 2);
	ПиктограммаОценка_4 = ?(Тек_Оценка >= 4, 0, 2);
	ПиктограммаОценка_5 = ?(Тек_Оценка >= 5, 0, 2);
	
	Если Тек_Оценка = 1 Тогда
		Показатель = НСтр("ru = 'Ужасно'");
		Цвет = Новый Цвет(191, 55, 1);
	ИначеЕсли Тек_Оценка = 2 Тогда
		Показатель = НСтр("ru = 'Плохо'");
		Цвет = Новый Цвет(255, 99, 72);
	ИначеЕсли Тек_Оценка = 3 Тогда
		Показатель = НСтр("ru = 'Нормально'");
		Цвет = Новый Цвет(255, 165, 0);
	ИначеЕсли Тек_Оценка = 4 Тогда
		Показатель = НСтр("ru = 'Хорошо'");
		Цвет = Новый Цвет(28, 116, 28);
	ИначеЕсли Тек_Оценка = 5 Тогда
		Показатель = НСтр("ru = 'Отлично'");
		Цвет = Новый Цвет(50, 205, 50);
	Иначе
		Показатель = "";
		Цвет = Новый Цвет(51, 51, 51);
	КонецЕсли;
	
	Элементы.Показатель.ЦветТекста = Цвет;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекущуюДату()
	Возврат ТекущаяДатаСеанса();	
КонецФункции


#КонецОбласти













